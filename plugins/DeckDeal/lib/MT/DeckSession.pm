package MT::DeckSession;
use strict;

use base qw( MT::Object );

__PACKAGE__->install_properties ({
    column_defs => {
        'id'          => 'integer not null auto_increment',
        'deckdata_id' => 'integer',
    },
    indexes => {
        created_on => 1,
        modified_on => 1,
    },
    audit => 1,
    datasource  => 'deck_session',
    primary_key => 'id',
    class_type  => 'deck_session',
});
