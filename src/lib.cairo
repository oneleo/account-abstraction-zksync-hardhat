/// Interface representing `HelloContract`.
/// This interface allows modification and retrieval of the contract balance.
///
// Define an interface named IHelloStarknet
#[starknet::interface]
pub trait IHelloStarknet<TContractState> {
    /// Increase contract balance.

    // Define the increase_balance function, which increases the contract's balance
    // The function takes `amount` as a parameter, of type felt252, and uses `ref self` to reference
    // the contract's state.
    fn increase_balance(ref self: TContractState, amount: felt252);

    /// Retrieve contract balance.

    // Define the get_balance function, which returns the current contract's balance
    // This function has no parameters and will return a value of type `felt252`
    fn get_balance(self: @TContractState) -> felt252;
}

/// Simple contract for managing balance.

// Define a StarkNet contract named HelloStarknet
#[starknet::contract]
mod HelloStarknet { // The identifier after "mod" indicates the contract name, which is HelloStarknet.
    use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    // Define the contract's state structure `Storage`, used to store the contract's data
    #[storage]
    struct Storage {
        // Define a member variable `balance` of type `felt252`
        // This will be used to store the contract's balance
        balance: felt252,
    }

    // Define the implementation part of the contract, which implements the methods of the
    // IHelloStarknet interface The `embed_v0` ABI is used here to handle interactions with the
    // outside world
    #[abi(embed_v0)]
    impl HelloStarknetImpl of super::IHelloStarknet<ContractState> {
        // Implement the increase_balance function to increase the balance
        // `self` refers to the contract's state, and `amount` is the value to be added
        fn increase_balance(ref self: ContractState, amount: felt252) {
            // Ensure that the `amount` to be added is not 0
            assert(amount != 0, 'Amount cannot be 0');

            // Update the `balance` value by reading the current `balance`, adding `amount`, and
            // writing it back to the state
            self.balance.write(self.balance.read() + amount);
        }

        // Implement the get_balance function to return the current balance
        // `self` is a reference to the contract's state, and this function reads and returns the
        // `balance` value
        fn get_balance(self: @ContractState) -> felt252 {
            // Read and return the current value of `balance`
            self.balance.read()
        }
    }
}
