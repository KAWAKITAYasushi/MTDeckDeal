package MT::Card;
use strict;

use base qw( MT::Object );

__PACKAGE__->install_properties ({
    column_defs => {
        'id'          => 'integer not null auto_increment',
        'cardtype_id' => 'integer not null',
        'name'    => 'string(255) not null',
        'label'    => 'string(255)',
        'type'    => 'string(255)',
        'value'   => 'integer'.
        'option'  => 'boolean',
    },
    indexes => {
        cardtype_id => 1,
    },
    audit => 1,
    datasource  => 'card',
    primary_key => 'id',
    class_type  => 'card',
});
