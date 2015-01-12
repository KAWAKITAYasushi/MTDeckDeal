package MT::DeckData;
use strict;

use base qw( MT::Object );

__PACKAGE__->install_properties ({
    column_defs => {
        'id'        => 'integer not null auto_increment',
        'card_id'   => 'integer',
        'place'     => 'integer',
        'player_id' => 'integer',
        'backside' => 'boolean',
        'reverse' => 'boolean',
    },
    indexes => {
        card_id => 1,
        place => 1,
        player_id => 1,
        created_on => 1,
        modified_on => 1,
    },
    audit => 1,
    datasource  => 'deck_data',
    primary_key => 'id',
    class_type  => 'deckdata',
});
