# Compress a WordPress site in a Digital Ocean droplet.

`ssh` into your droplet.
```sh
ssh root@__droplet_ip__
```

Copy the `wp_compress.sh` file into the root directory and run it.

```sh
wget -O wp_compress.sh https://raw.githubusercontent.com/mvallejo3/compress-wp/main/digitalocean/wp_compress.sh
chmod +x wp_compress.sh
# pass filename 
./wp_compress.sh __filename__
```
