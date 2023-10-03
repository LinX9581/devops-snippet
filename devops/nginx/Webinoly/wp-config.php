<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wp_db' );

/** MySQL database username */
define( 'DB_USER', 'dev' );

/** MySQL database password */
define( 'DB_PASSWORD', '00000000' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'wRtg0nH>$E`j5(mC[_W)Hqe0~`&qWlt=]s#+84n@W=FQ2ZU)?/~ug;uI0nN-W?Oe' );
define( 'SECURE_AUTH_KEY',  'zluFU?&lcl27!3hA~XaqY{cAgqQ+*<+|xs(/cDdj!k~C@f!?&c$pf~,?le0g#}<;' );
define( 'LOGGED_IN_KEY',    '{[v/]ZXW_jIjjxd2m=v#X|c-Tc/DRGDL*U;isokp-C?wC<z@+PMx~K$xm:P`2PTE' );
define( 'NONCE_KEY',        '_Twai+zKlVz0p 1Wx[jQ99*kYhtb7w`J6uZa;h:.RW/J_9Fdkg*){m4<OWf~=^nG' );
define( 'AUTH_SALT',        '#s!a3:%XcBQCfHBGK &1163x(]T;V;Z0{Oo<<?J/eLop2{mf%u_gN|S1zUWWF6As' );
define( 'SECURE_AUTH_SALT', 'Sm1dFQF>J[D*:3xanv#@J^1>yV[w4|29]_xPOcM}$T}Z_gYYT,BT?R Lh@jv;qZh' );
define( 'LOGGED_IN_SALT',   'h&WW4x:>B?R:(lZ>=H$dZ;s}KMZ6tmJ^jIv=/ye|}Rf{Wp2uMfxe;P/kIgZaLC<u' );
define( 'NONCE_SALT',       'vYcXx$P;iPnoK)f[aeg7OZx(q[x7i=ZdCicWW$H12e?V.I>cx))Pi,uC{h|)*e|@' );


# define('WP_SITEURL', 'https://www.linxnote.club');
# define('WP_HOME', 'http://www.linxnote.club');
/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );
