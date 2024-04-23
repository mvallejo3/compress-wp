# compress-wp

This repo helps you compress (and decompress) a WordPress site. You can use this functionality to create and restore backups or to migrate a site from one server to another.

There are 2 scripts:
- `wp_compress.sh`. This script creates a compressed archive that contains the following items:
  - All the files inside themes, plugins, uploads, and mu-plugins.
  - A backup of the Wordpress database.
- `wp_unpack.sh`. This script decompresses the archive and updates the database and the wp-content directory.

Choose the version of the sripts that matches your hositng provider/setup when using it.
Any hosting provider can choose to structure Wordpress slightly different. In order for these scripts to know where to go to find the right directories, they need to know a little bit about your servers.

The plan is to continue to add more providers as we encounter them, but for now, the script supports the following servers:
- [DigitalOcean WordPress droplet](https://marketplace.digitalocean.com/apps/wordpress).
- [CloudPanel WordPress site](https://www.cloudpanel.io/).
