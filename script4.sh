yum install -y wget
yum install -y gzip
wget  https://ftp.drupal.org/files/projects/drupal-8.2.6.tar.gz
tar -zxvf drupal-8.2.6.tar.gz
mv drupal-8.2.6 /var/www/html/drupal
cd /var/www/html/drupal/sites/default/
cp default.settings.php settings.php
chown -R apache:apache /var/www/html/drupal/
chcon -R -t httpd_sys_content_rw_t /var/www/html/drupal/sites/
