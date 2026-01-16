# 🚀 iCloud Photo & Video Downloader

A simple yet powerful Python script to download and back up your photos and albums from iCloud.

![Made with Python](https://img.shields.io/badge/Made%20with-Python-1f425f.svg)

![Demo](https://i.imgur.com/tL4g1zC.gif)

This command-line tool provides an easy way to automate the backup of your Apple Photos library.

## ✨ Features

- **Easy to Use**: Simple and intuitive command-line interface (CLI).
- **🔒 Secure**: Uses environment variables (`.env` file) to handle your Apple ID and password securely. Your credentials are not hard-coded or exposed in your shell history.
- **📱 2FA Support**: Full support for Two-Factor Authentication (2FA) by prompting for the code when required.
- **🗂️ Flexible Downloading**:
  - Download all photos from a specific album.
  - Download photos and videos from *all* your albums at once into organized folders.
- **📊 Progress Bars**: Clean visual feedback on download progress using `tqdm`.
- **💪 Resilient**: Skips files that fail to download and continues with the rest, ensuring the backup process completes.

## 📦 Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/icloud-downloader.git
    cd icloud-downloader
    ```

2.  **Install dependencies:**
    It's highly recommended to use a Python virtual environment.
    ```bash
    # Create a virtual environment
    python -m venv venv

    # Activate it
    source venv/bin/activate  # On Windows, use `venv\Scripts\activate`
    ```
    Then, install the required packages:
    ```bash
    pip install -r requirements.txt
    ```

## 💡 Usage

### 1. 🔑 Set Up Your Credentials

For maximum security, the tool is designed to read your Apple ID and password from a `.env` file in the project directory.

1.  Create a file named `.env`:
    ```bash
    touch .env
    ```

2.  Add your credentials to the `.env` file like this:
    ```
    APPLE_ID=your_apple_id@example.com
    APPLE_PASSWORD=your_super_secret_password
    ```

> **Note**: The `.gitignore` file is already configured to ignore `.env` files, so you won't accidentally commit your credentials. If you prefer not to use a `.env` file, the script will securely prompt you to enter your credentials when you run it.

### 2. ▶️ Run the Downloader

Execute the script using `python` from your terminal.

**To download the "All Photos" album to a default `iCloud_Photos` directory:**
```bash
python icloud_downloader.py
```

**To specify a different album:**
```bash
python icloud_downloader.py --album "Summer Vacation"
```

**To specify a different download directory:**
```bash
python icloud_downloader.py --directory "./My_iCloud_Backup"
```

**To download ALL albums into separate folders:**
This will create a main directory and place each album inside its own sub-folder, replicating your iCloud structure.
```bash
python icloud_downloader.py --all-albums
```

### ⚙️ Command Options

| Option        | Argument          | Description                                                                                             | Default         |
|---------------|-------------------|---------------------------------------------------------------------------------------------------------|-----------------|
| `--directory` | `<path>`          | The directory where photos will be saved.                                                               | `iCloud_Photos` |
| `--album`     | `<"Album Name">`  | The name of the album to download.                                                                      | `"All Photos"`  |
| `--all-albums`|                   | If set, downloads all albums into sub-folders. This overrides the `--album` option.                     | `False`         |


### ✨ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=ishandutta2007/icloud-downloader&type=date&legend=top-left)](https://www.star-history.com/#ishandutta2007/icloud-downloader&type=date&legend=top-left)

### 💬 Community & Support

-   **📚 [Documentation](https://docs.open-workflows.com):** Check out our official documentation for detailed guides and tutorials.
-   **🗣️ [Forum](https://community.open-workflows.com):** Join our community forum to ask questions, share your projects, and connect with other users.
-   **💬 [Discord](https://discord.com/invite/jc4xtF58Ve):** Chat with us on Discord for real-time support and discussions.
-   **🐦 [Twitter](https://twitter.com/ishandutta2007):** Follow us on Twitter for the latest news and updates.
-   **🐦 [Github](https://github.com/ishandutta2007):** Follow me on Github for the latest commits and updates.

## 💖 Support & Sponsorship

If you find this project helpful or if it has saved you time and resources, please consider sponsoring the development. Your support helps maintain the project, develop new features, and keep the initiative open-source.

**[Sponsor @ishandutta2007 on GitHub](https://github.com/sponsors/ishandutta2007)**

Every contribution, no matter how small, makes a huge difference!

## ⚠️ Disclaimer

This tool is an unofficial, third-party utility and is not affiliated with Apple Inc. Storing your Apple ID and password in any file can be a security risk. Please use this tool at your own risk and ensure your `.env` file is kept secure and is never committed to any version control system.