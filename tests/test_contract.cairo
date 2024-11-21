// Import `ContractAddress`, which is a type used to handle contract addresses
use starknet::ContractAddress;

// Import several modules from the `snforge_std` library, which provide functionalities for
// deploying contracts and handling contract types
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};

// Import several interfaces from the `starknet_call_self_function` library, which are related to
// calls of the `HelloStarknet` contract
use starknet_call_self_function::IHelloStarknetSafeDispatcher;
use starknet_call_self_function::IHelloStarknetSafeDispatcherTrait;
use starknet_call_self_function::IHelloStarknetDispatcher;
use starknet_call_self_function::IHelloStarknetDispatcherTrait;

// Define a `deploy_contract` function that is responsible for deploying a contract and returning
// its address The `name` parameter is the contract name, represented as a `ByteArray`
fn deploy_contract(name: ByteArray) -> ContractAddress {
    // Use the `declare` function to declare the contract and get its type, then use
    // `contract_class()` to obtain the contract class
    let contract = declare(name).unwrap().contract_class();

    // Deploy the contract and obtain its address and result (we only need the address)
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();

    // Return the deployed contract's address
    contract_address
}

// Define a test function `test_increase_balance` to test the balance increase functionality
#[test]
fn test_increase_balance() {
    // Deploy the contract and obtain its address
    let contract_address = deploy_contract("HelloStarknet");

    // Use `IHelloStarknetDispatcher` to create a dispatcher instance that will operate the contract
    let dispatcher = IHelloStarknetDispatcher { contract_address };

    // Get the balance before deployment
    let balance_before = dispatcher.get_balance();

    // Assert that the contract balance is 0, if not, the test will fail
    assert(balance_before == 0, 'Invalid balance');

    // Call `increase_balance` function to increase the balance by 42
    dispatcher.increase_balance(42);

    // Get the balance after increasing the balance
    let balance_after = dispatcher.get_balance();

    // Assert that the contract balance is 42, if not, the test will fail
    assert(balance_after == 42, 'Invalid balance');
}

// Define another test function `test_cannot_increase_balance_with_zero_value` to test that 0 cannot
// be used as the value to increase the balance
#[test]
#[feature("safe_dispatcher")]
fn test_cannot_increase_balance_with_zero_value() {
    // Deploy the contract and obtain its address
    let contract_address = deploy_contract("HelloStarknet");

    // Create a safe dispatcher instance using `IHelloStarknetSafeDispatcher`
    let safe_dispatcher = IHelloStarknetSafeDispatcher { contract_address };

    // Get the balance before deployment
    let balance_before = safe_dispatcher.get_balance().unwrap();

    // Assert that the contract balance is 0, if not, the test will fail
    assert(balance_before == 0, 'Invalid balance');

    // Attempt to call `increase_balance` to increase the balance with a value of 0
    match safe_dispatcher.increase_balance(0) {
        // If the result is success, it should panic (should fail), trigger an error manually if it
        // does not fail
        Result::Ok(_) => core::panic_with_felt252('Should have panicked'),
        // If the result is an error, check the error message
        Result::Err(panic_data) => {
            // Assert that the error message is "Amount cannot be 0", if not, the test will fail
            assert(*panic_data.at(0) == 'Amount cannot be 0', *panic_data.at(0));
        }
    };
}
