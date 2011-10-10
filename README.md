# setec astronomy

<img src="http://www.cyberpunkreview.com/wp-content/uploads/toomanysecrets.gif" />

# almost ready for initial release!

a `setec` command is included with two basic commands:

`setec search PATTERN -f /path/to/passwords.kdb` will search your password database and output matching entries

`setec copy ENTRY_TITLE -f /path/to/passwords.kdb` will copy the password for the entry you specify straight into the clipboard

with no options, the master password is requested on the console.  add the `-g` option to have the password prompt be an applescript-based gui dialog.  this is especially useful when using this library for alfred integration.

an example alfred extension is included at `alfred/setec.alfredextension` - it assumes that you have this library checked out in `$HOME/dev/setec_astronomy` and all of the required gems installed in the gemset.  you need the alfred powerpack to install the extension.  (it's pretty easy to take a look at the command used by the extension and modify it.)  assuming you get this all set up properly, you can type "stc test entry" into alfred and--if you type the master password properly--see the test password gets copied into your clipboard.

# security warning

no attempt is made to protect the memory used by this library; there may be something we can do with libgcrypt's secure-malloc functions, but right now your master password is unencrypted in ram that could possibly be paged to disk.
