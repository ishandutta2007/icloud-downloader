import os
import click
import sys
from tqdm import tqdm
from pyicloud import PyiCloudService
from pyicloud.exceptions import PyiCloudFailedLoginException
from dotenv import load_dotenv

def get_api():
    """Authenticate with iCloud and return the API object."""
    load_dotenv()
    apple_id = os.getenv("APPLE_ID")
    password = os.getenv("APPLE_PASSWORD")

    if not apple_id:
        apple_id = click.prompt("Enter your Apple ID")
    if not password:
        password = click.prompt("Enter your Apple Password", hide_input=True)

    try:
        api = PyiCloudService(apple_id, password)
    except PyiCloudFailedLoginException:
        click.echo("Error: Invalid Apple ID or password.", err=True)
        sys.exit(1)

    if api.requires_2fa:
        click.echo("Two-factor authentication required.")
        code = click.prompt("Enter the code you received on your device")
        result = api.validate_2fa_code(code)
        if not result:
            click.echo("Error: Failed to verify 2FA code.", err=True)
            sys.exit(1)
        click.echo("2FA successful.")

    return api

@click.command()
@click.option('--directory', default='iCloud_Photos', help='The directory to download photos to.')
@click.option('--album', default='All Photos', help='The name of the album to download. Defaults to "All Photos".')
@click.option('--all-albums', is_flag=True, help='Download all albums.')
def download(directory, album, all_albums):
    """A command-line tool to download photos from iCloud."""
    
    api = get_api()
    
    # Create the download directory if it doesn't exist
    if not os.path.exists(directory):
        os.makedirs(directory)

    if all_albums:
        albums = api.photos.albums
        for album_name, photo_album in albums.items():
            album_dir = os.path.join(directory, album_name)
            if not os.path.exists(album_dir):
                os.makedirs(album_dir)
            
            click.echo(f"Downloading album: {album_name}...")
            download_photos_from_album(photo_album, album_dir)
    else:
        try:
            photo_album = api.photos.albums[album]
            click.echo(f"Downloading album: {album}...")
            download_photos_from_album(photo_album, directory)
        except KeyError:
            click.echo(f"Error: Album '{album}' not found.", err=True)
            click.echo("Available albums: " + ", ".join(api.photos.albums.keys()))
            sys.exit(1)

    click.echo("Download complete.")

def download_photos_from_album(album, directory):
    """Downloads all photos from a given album to a directory."""
    photos = list(album.photos)
    with tqdm(total=len(photos), desc=f"Downloading to {directory}") as pbar:
        for photo in photos:
            try:
                download = photo.download()
                if download:
                    file_path = os.path.join(directory, photo.filename)
                    with open(file_path, 'wb') as f:
                        f.write(download.raw.read())
                pbar.update(1)
            except Exception as e:
                click.echo(f"Could not download {photo.filename}. Reason: {e}", err=True)
                pbar.update(1)


if __name__ == '__main__':
    download()
