/* Interface between the client and the rest of CVS.  */

/* Stuff shared with the server.  */
extern char *mode_to_string PROTO((mode_t));
extern int change_mode PROTO((char *, char *));

extern int gzip_level;
extern int file_gzip_level;
extern int filter_through_gzip PROTO((int, int, int, pid_t *));
extern int filter_through_gunzip PROTO((int, int, pid_t *));

#if defined (CLIENT_SUPPORT) || defined (SERVER_SUPPORT)

extern int cvsencrypt;

#ifdef ENCRYPTION
#ifdef HAVE_KERBEROS

/* We can't declare the arguments without including krb.h, and I don't
   want to do that in every file.  */
extern struct buffer *krb_encrypt_buffer_initialize ();

#endif /* HAVE_KERBEROS */
#endif /* ENCRYPTION */

#endif /* defined (CLIENT_SUPPORT) || defined (SERVER_SUPPORT) */

#ifdef CLIENT_SUPPORT
/*
 * Flag variable for seeing whether the server has been started yet.
 * As of this writing, only edit.c:notify_check() uses it.
 */
extern int server_started;

/* Is the -P option to checkout or update specified?  */
extern int client_prune_dirs;

#ifdef AUTH_CLIENT_SUPPORT
extern int use_authenticating_server;
int connect_to_pserver PROTO((int *tofdp, int* fromfdp, int verify_only));
# ifndef CVS_AUTH_PORT
# define CVS_AUTH_PORT 2401
# endif /* CVS_AUTH_PORT */
#endif /* AUTH_CLIENT_SUPPORT */

#ifdef AUTH_SERVER_SUPPORT
extern void pserver_authenticate_connection PROTO ((void));
#endif

#if defined (SERVER_SUPPORT) && defined (HAVE_KERBEROS)
extern void kserver_authenticate_connection PROTO ((void));
#endif

/* Talking to the server. */
void send_to_server PROTO((char *str, size_t len));
void read_from_server PROTO((char *buf, size_t len));

/* Internal functions that handle client communication to server, etc.  */
int supported_request PROTO ((char *));
void option_with_arg PROTO((char *option, char *arg));

/* Get the responses and then close the connection.  */
extern int get_responses_and_close PROTO((void));

extern int get_server_responses PROTO((void));

/* Start up the connection to the server on the other end.  */
void
start_server PROTO((void));

/* Send the names of all the argument files to the server.  */
void
send_file_names PROTO((int argc, char **argv, unsigned int flags));

/* Flags for send_file_names.  */
/* Expand wild cards?  */
#define SEND_EXPAND_WILD 1

/*
 * Send Repository, Modified and Entry.  argc and argv contain only
 * the files to operate on (or empty for everything), not options.
 * local is nonzero if we should not recurse (-l option).
 */
void
send_files PROTO((int argc, char **argv, int local, int aflag));

/*
 * Like send_files but never send "Unchanged"--just send the contents of the
 * file in that case.  This is used to fix it if you import a directory which
 * happens to have CVS directories (yes it is obscure but the testsuite tests
 * it).
 */
void
send_files_contents PROTO((int argc, char **argv, int local, int aflag));

/* Send an argument to the remote server.  */
void
send_arg PROTO((char *string));

/* Send a string of single-char options to the remote server, one by one.  */
void
send_option_string PROTO((char *string));

#endif /* CLIENT_SUPPORT */

/*
 * This structure is used to catalog the responses the client is
 * prepared to see from the server.
 */

struct response
{
    /* Name of the response.  */
    char *name;

#ifdef CLIENT_SUPPORT
    /*
     * Function to carry out the response.  ARGS is the text of the
     * command after name and, if present, a single space, have been
     * stripped off.  The function can scribble into ARGS if it wants.
     */
    void (*func) PROTO((char *args, int len));

    /*
     * ok and error are special; they indicate we are at the end of the
     * responses, and error indicates we should exit with nonzero
     * exitstatus.
     */
    enum {response_type_normal, response_type_ok, response_type_error} type;
#endif

    /* Used by the server to indicate whether response is supported by
       the client, as set by the Valid-responses request.  */
    enum {
      /*
       * Failure to implement this response can imply a fatal
       * error.  This should be set only for responses which were in the
       * original version of the protocol; it should not be set for new
       * responses.
       */
      rs_essential,

      /* Some clients might not understand this response.  */
      rs_optional,

      /*
       * Set by the server to one of the following based on what this
       * client actually supports.
       */
      rs_supported,
      rs_not_supported
      } status;
};

/* Table of responses ending in an entry with a NULL name.  */

extern struct response responses[];

#ifdef CLIENT_SUPPORT

extern void client_senddate PROTO((const char *date));
extern void client_expand_modules PROTO((int argc, char **argv, int local));
extern void client_send_expansions PROTO((int local, char *where));
extern void client_nonexpanded_setup PROTO((void));

extern void send_init_command PROTO ((void));

extern char **failed_patches;
extern int failed_patches_count;
extern char toplevel_wd[];
extern void client_import_setup PROTO((char *repository));
extern int client_process_import_file
    PROTO((char *message, char *vfile, char *vtag,
	   int targc, char *targv[], char *repository));
extern void client_import_done PROTO((void));
extern void client_notify PROTO((char *, char *, char *, int, char *));
#endif /* CLIENT_SUPPORT */
