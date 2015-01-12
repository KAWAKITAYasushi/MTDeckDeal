package MT::CardType;
use strict;

use base qw( MT::Object );

__PACKAGE__->install_properties ({
    column_defs => {
        'id'      => 'integer not null auto_increment',
        'name'    => 'string(255) not null',
        'count'   => 'integer not null'.
        'detail'  => 'text',
    },
    audit => 1,
    datasource  => 'cardtype',
    primary_key => 'id',
    class_type  => 'cardtype',
});
