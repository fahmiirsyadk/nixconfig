{
  enable = true;
  adminAddr = "fahmiirsyadk";
  virtualHosts = {
    "localhost" = {
      documentRoot = "/var/www/html";
      adminAddr = "fahmiirsyad10@gmail.com";
      extraConfig = ''
        <Directory "/var/www/html">
           Options Indexes FollowSymLinks
           AllowOverride None
           Allow from all
           Require all granted
        </Directory>
      '';
      listen = [{ port = 2345; }];
    };
  };

  enablePHP = true;
  phpOptions = ''
    date.timezone = Asia/Jakarta
    display_errors = on
    extension=gd
    extension=imap
    extension=mysqli
    extension=pdo_mysql
    extension=bz2
  '';
}
