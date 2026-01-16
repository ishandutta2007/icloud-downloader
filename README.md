# iCloud Photo Downloader

A simple yet powerful command-line tool to download your photos and albums from iCloud.

![Demo](https://i.imgur.com/tL4g1zC.gif)

## Features

- **Easy to Use**: Simple command-line interface.
- **Secure**: Uses environment variables to handle your Apple ID and password, so they are not hard-coded or exposed in your shell history.
- **Two-Factor Authentication (2FA) Support**: Prompts for 2FA code if required.
- **Flexible Downloading**:
  - Download all photos from a specific album.
  - Download photos from *all* your albums at once.
- **Progress Bars**: Visual feedback on download progress.
- **Resilient**: Skips files that fail to download and continues with the rest.

## Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/icloud-downloader.git
    cd icloud-downloader
    ```

2.  **Install dependencies:**
    It's recommended to use a virtual environment.
    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows, use `venv\Scripts\activate`
    ```
    Then, install the required packages:
    ```bash
    pip install -r requirements.txt
    ```

## Usage

### 1. Set Up Your Credentials

For security, the tool is designed to read your Apple ID and password from a `.env` file in the project directory.

1.  Create a file named `.env`:
    ```bash
    touch .env
    ```

2.  Add your credentials to the `.env` file like this:
    ```
    APPLE_ID=your_apple_id@example.com
    APPLE_PASSWORD=your_super_secret_password
    ```

> **Note**: The `.gitignore` file is already configured to ignore `.env` files, so you won't accidentally commit your credentials. If you prefer not to use a `.env` file, the script will prompt you to enter your credentials when you run it.

### 2. Run the Downloader

Execute the script using `python`:

**To download the "All Photos" album to a `iCloud_Photos` directory:**
```bash
python icloud_downloader.py
```

**To specify a different album:**
```bash
python icloud_downloader.py --album "Your Album Name"
```

**To specify a different download directory:**
```bash
python icloud_downloader.py --directory "./My_Downloads"
```

**To download all albums into separate folders:**
This will create a main directory (e.g., `iCloud_Photos`) and place each album inside its own sub-folder.
```bash
python icloud_downloader.py --all-albums
```

### Command Options

| Option        | Argument          | Description                                                                                             | Default         |
|---------------|-------------------|---------------------------------------------------------------------------------------------------------|-----------------|
| `--directory` | `<path>`          | The directory where photos will be saved.                                                               | `iCloud_Photos` |
| `--album`     | `<"Album Name">`  | The name of the album to download.                                                                      | `"All Photos"`  |
| `--all-albums`|                   | If set, downloads all albums into sub-folders. This overrides the `--album` option.                     | `False`         |


## Disclaimer

This tool is not affiliated with Apple Inc. It is a third-party utility. Storing your Apple ID and password in a file can be a security risk. Please use this tool at your own risk and ensure your `.env` file is kept secure and is not committed to any version control system.