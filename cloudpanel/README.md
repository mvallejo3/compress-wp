# Unpack a WordPress site

Upload your archive file into a cloudpanel server.

```sh
scp ~/Desktop/__filename__tar.gz root@__cp_ip__:
```

`ssh` into your the cloudpanel server.

```sh
ssh root@__cp_ip__
```

Copy the `wp_unpack.sh` file into the root directory and run it.

```sh
wget -O wp_unpack.sh https://raw.githubusercontent.com/mvallejo3/compress-wp/main/cloudpanel/wp_unpack.sh
chmod +x wp_unpack.sh
# pass filename 
./wp_unpack.sh __filename__
```
