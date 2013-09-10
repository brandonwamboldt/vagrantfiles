<?php

/**
 * This is an example file. Please move to wp-config.php and configure with
 * parameters specific to your installation. The real wp-config.php is not part
 * of the version control repo as it contains passwords and server specific
 * configuration variables.
 */

// Enter your database info here
define('DB_NAME', 'wordpress');
define('DB_USER', 'root');
define('DB_PASSWORD', '');
define('DB_HOST', 'localhost');

// Default database settings
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
define('DB_TABLE_PREFIX', 'wp_');

// Set the max upload size to 128mb
define('WP_MAX_UPLOAD_FILESIZE', '128M');

// This makes it easier to setup new environments by dynamically getting the
// host name
define('WP_SITEURL', 'http://' . $_SERVER['HTTP_HOST']);
define('WP_HOME', WP_SITEURL);

// This allows us to run WordPress updates and plugin updates from the admin UI
// without entering FTP info.
define('FS_METHOD', 'direct');

// WordPress Localized Language, defaults to English.
define('WPLANG', '');

// Enable debugging mode in dev environments
define('WP_DEBUG', true);

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'B(yJ}0XYS5Q|X-F1 tcH?|g-<@1$OL9b=I23JIjF ^Z6BT~II8uN7?#!0WMq_HF7');
define('SECURE_AUTH_KEY',  ',GLRhYpMFj/Z{<P;s=~tC_A/|9paf=Kb57}+zmf^J~,S#JUp40P<(<m+&pJ9mK`p');
define('LOGGED_IN_KEY',    '|*GNC8=p$<asH|!,$doSmbVq)v+f/_--+ubEITzwj.UU%eeewvqH^Ypj~ (%jf,[');
define('NONCE_KEY',        '||S+=@NdDsm*v()lf}^RDdde7hhL4y-(t?|Z<9,j~*^:Yb$K?@C$>G0z7?Mn2RQR');
define('AUTH_SALT',        'Cj{%m#Re%K|&b_N0R~6{18=yy.]vbK1DP|N~&+ADejW-0hf3^gQ3F_5f9Bsr+U=-');
define('SECURE_AUTH_SALT', 'xr!7N|oU8!Cz+RXcF gT-_0ZUS`cW;BQ(aQi]u<]w-n V<?7U9j3s}.vt=yE:+]=');
define('LOGGED_IN_SALT',   'O%Kzac,-0?i}A!NhKLBfLyiLRoQb:bS36Of84dCgKzlse/C?,F>bI?N;;ock?N)h');
define('NONCE_SALT',       '8+M}hTUxo))+s><_q_i HZwHc*+MA_%)i#=7*!- T3dP8/1sqd[%/[&Q-el#~jfW');

// WordPress Database Table prefix.
$table_prefix  = DB_TABLE_PREFIX;

// Absolute path to the WordPress directory.
if (!defined('ABSPATH')) {
    define('ABSPATH', dirname(__FILE__) . '/');
}

ini_set('upload_max_filesize', WP_MAX_UPLOAD_FILESIZE);
ini_set('post_max_size', WP_MAX_UPLOAD_FILESIZE);

// Sets up WordPress vars and included files.
require_once(ABSPATH . 'wp-settings.php');
