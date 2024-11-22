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

// Define a StarkNet contract named `MyAccount` and enable account functionality (`account`)
#[starknet::contract(account)]
mod MyAccount {
    // Import the AccountComponent from OpenZeppelin, which handles account-related features
    use openzeppelin::account::AccountComponent;

    // Import the SRC5 component for standard compatibility checks within the contract
    use openzeppelin::introspection::src5::SRC5Component;

    // Import functionality for reading and writing StarkNet storage pointers
    use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    // Import the `ContractAddress` type to represent contract addresses
    use core::starknet::ContractAddress;

    // Import the `contract_address_const` function to obtain constant contract addresses
    use core::starknet::contract_address_const;

    // Define an account component pointing to the OpenZeppelin AccountComponent, specifying its
    // storage and event names
    component!(path: AccountComponent, storage: account, event: AccountEvent);

    // Define an SRC5 component pointing to the OpenZeppelin SRC5Component, specifying its storage
    // and event names
    component!(path: SRC5Component, storage: src5, event: SRC5Event);

    // Implement the `AccountMixinImpl` from the AccountComponent for account-related
    // functionalities
    // Account Mixin
    #[abi(embed_v0)]
    impl AccountMixinImpl = AccountComponent::AccountMixinImpl<ContractState>;

    // Implement internal logic for accounts using `AccountComponent::InternalImpl`
    impl AccountInternalImpl = AccountComponent::InternalImpl<ContractState>;

    // Define the storage structure for the contract
    #[storage]
    struct Storage {
        // Store data related to the account component
        #[substorage(v0)]
        account: AccountComponent::Storage,
        // Store data related to the SRC5 component
        #[substorage(v0)]
        src5: SRC5Component::Storage,
        // Define a custom variable of type `felt252`
        custom_variable: felt252,
    }

    // Define events for the contract
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        // Include events from the account component
        #[flat]
        AccountEvent: AccountComponent::Event,
        // Include events from the SRC5 component
        #[flat]
        SRC5Event: SRC5Component::Event
    }

    // The constructor initializes the contract
    #[constructor]
    fn constructor(ref self: ContractState, public_key: felt252) {
        // Initialize the account with the provided public key
        self.account.initializer(public_key);
    }

    // Custom function to set `custom_variable` to 1
    #[external(v0)]
    fn custom_function1(ref self: ContractState) {
        self.custom_variable.write(1);
    }

    // Custom function that can only be called by the Sequencer
    #[external(v0)]
    fn custom_function2(ref self: ContractState) {
        // Retrieve the address of the caller
        let caller = starknet::get_caller_address();

        // Retrieve the address of the Sequencer contract
        let sequencer_address = get_sequencer_address();

        // Ensure the caller is the Sequencer
        assert(caller == sequencer_address, 'Only sequencer can call');

        // Set `custom_variable` to 2
        self.custom_variable.write(2);
    }

    // Custom function that can only be called by the contract itself
    #[external(v0)]
    fn custom_function3(ref self: ContractState) {
        // Retrieve the address of the caller
        let caller = starknet::get_caller_address();

        // Retrieve the current contract's address
        let contract_address = starknet::get_contract_address();

        // Ensure the caller is the contract itself
        assert(caller == contract_address, 'Only the account can call');

        // Set `custom_variable` to 3
        self.custom_variable.write(3);
    }

    // Custom function to return the value of `custom_variable`
    #[external(v0)]
    fn get_custom_variable(self: @ContractState) -> felt252 {
        self.custom_variable.read()
    }

    // Return the Sequencer contract's address
    fn get_sequencer_address() -> ContractAddress {
        // Use a constant address
        contract_address_const::<
            0x01176a1bd84444c89232ec27754698e5d2e7e1a7f1539f12027f28b23ec9f3d8
        >()
    }
}
