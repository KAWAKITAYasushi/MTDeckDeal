package MT::CardType;
use strict;

use base qw( MT::Object );

__PACKAGE__->install_properties ({
    column_defs => {
        'id'      => 'integer not null auto_increment',
        'name'    => 'string(255)',
        'quantity'   => 'integer',
        'detail'  => 'text',
    },
    audit => 1,
    datasource  => 'card_type',
    primary_key => 'id',
    class_type  => 'card_type',
});
