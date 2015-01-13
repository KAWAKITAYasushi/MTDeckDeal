package MT::DeckType;
use strict;

use base qw( MT::Object );

__PACKAGE__->install_properties ({
    column_defs => {
        'id'          => 'integer not null auto_increment',
        'name'        => 'string(255)',
        'cardtype_id' => 'integer',
        'quantity'    => 'integer',
        'setcount'    => 'integer',
        'must'        => 'text',
        'nouse'       => 'text',
    },
    indexes => {
        cardtype_id => 1,
        created_on => 1,
        modified_on => 1,
    },
    audit => 1,
    datasource  => 'deck_type',
    primary_key => 'id',
    class_type  => 'deck_type',
});
