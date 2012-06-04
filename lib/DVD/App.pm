package DVD::App;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Crypt::SaltedHash;
use DVD::DVDList;

our $VERSION = '0.1';

get '/'                 => sub {
    template 'index.tt';
};

#hook 'before'           => sub {
    
#    my $path = request->path_info;
    
#    if ( !session( 'user' ) && $path !~ m{^/login} && $path !~ m{^/register} ) {
#        var requested_path => request->path_info;
#        request->path_info( '/login' );
#    }
#};

get '/login'            => sub {
    # Display a login page; the original URL they requested is available as
    # vars->{requested_path}, so could be put in a hidden field in the form
    template 'login.tt', { path => vars->{ requested_path } };
};

post '/login'           => sub {
    my $user = database->quick_select( 'users', 
        { username => params->{ user } }
    );
    
    if ( !$user ) {
        warning "Failed login for unrecognised user " . params->{ user };
        redirect '/login?failed=1';
    } else {
        if ( Crypt::SaltedHash->validate( $user->{ password }, params->{ pass } ) ) {
            debug "Password correct";
            # Logged in successfully
            session user => $user;
            redirect params->{ path } || '/';
        } else {
            debug( "Login failed - password incorrect for " . params->{ user } );
            redirect '/login?failed=1';
        }
    }
};

get '/list'             => sub {
    my $list = DVD::DVDList->new();
    print $list->get_dvd_list();
    #template 'list.tt';
};

get '/register'         => sub {
    template 'register.tt'  
};

post '/register/new'    => sub {
    print 'trying hard enough: ' . params->{ username } . '\n';    
};

true;
