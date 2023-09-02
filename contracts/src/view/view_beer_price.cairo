#[system]
mod view_beer_price {
    use core::debug::PrintTrait;
    use array::ArrayTrait;
    use core::traits::{Into};
    use starknet::{ContractAddress, get_block_timestamp};

    use cubit::f128::types::fixed::{Fixed, FixedTrait};
    use dojo::world::Context;

    use beer_barron::components::auction::{TavernAuction, TavernAuctionTrait};
    use beer_barron::components::balances::{GoldBalance};
    use beer_barron::vrgda::vrgda::ReverseLinearVRGDATrait;

    fn execute(ctx: Context, game_id: u64, item_id: u128) -> Fixed {
        let mut auction = get!(ctx.world, (game_id, item_id), TavernAuction);

        // convert auction to VRGDA
        let VRGDA = auction.to_ReverseLinearVRGDA();

        // time since auction start
        let time_since_start: u128 = get_block_timestamp().into() - auction.start_time.into();

        // get current price
        VRGDA
            .get_vrgda_price(
                FixedTrait::new((time_since_start), false), // time since start
                FixedTrait::new(auction.sold, false) // amount sold
            )
    }
}