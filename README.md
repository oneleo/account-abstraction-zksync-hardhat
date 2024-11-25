# Starknet Call Self Function

## Prerequire

- Setting up your environment
  - https://docs.starknet.io/quick-start/environment-setup/
  - Note: Install Scarb v2.8.2 using the asdf command

```sh
$ asdf install scarb 2.8.2
$ asdf global scarb 2.8.2
4 scarb --version
```

- Setting up an account using wallet
  - https://www.starknet.io/wallets/

## Build contracts

```sh
$ scarb build

### Output:

   Compiling snforge_scarb_plugin v0.33.0 (git+https://github.com/foundry-rs/starknet-foundry?tag=v0.33.0#221b1dbff42d650e9855afd4283508da8f8cacba)
    Finished `release` profile [optimized] target(s) in 0.38s
   Compiling starknet_call_self_function v0.1.0 (/Users/irara/MyGithub3/_home_of_tokens/StarkNet/starknet_call_self_function_git/Scarb.toml)
    Finished release target(s) in 4 seconds
```

## List available scripts

```sh
$ scarb run

### Output:

Scripts available via `scarb run`:
declare               : sncast --profile default --account mainuser declare --fee-token eth
deploy                : sncast --profile default --account mainuser deploy --fee-token eth
import                : sncast account import --name mainuser --add-profile default
test                  : snforge test
verify                : sncast --profile default --account mainuser verify --verifier walnut
```

## Run the Foundry test

```sh
$ scarb run test

### Output:

   Compiling snforge_scarb_plugin v0.33.0 (git+https://github.com/foundry-rs/starknet-foundry?tag=v0.33.0#221b1dbff42d650e9855afd4283508da8f8cacba)
    Finished `release` profile [optimized] target(s) in 0.47s
   Compiling starknet_call_self_function v0.1.0 (/Users/irara/MyGithub3/_home_of_tokens/StarkNet/starknet_call_self_function_git/Scarb.toml)
    Finished release target(s) in 4 seconds
   Compiling snforge_scarb_plugin v0.33.0 (git+https://github.com/foundry-rs/starknet-foundry?tag=v0.33.0#221b1dbff42d650e9855afd4283508da8f8cacba)
    Finished `release` profile [optimized] target(s) in 0.20s
   Compiling test(starknet_call_self_function_unittest) starknet_call_self_function v0.1.0 (/Users/irara/MyGithub3/_home_of_tokens/StarkNet/starknet_call_self_function_git/Scarb.toml)
   Compiling test(starknet_call_self_function_integrationtest) starknet_call_self_function_integrationtest v0.1.0 (/Users/irara/MyGithub3/_home_of_tokens/StarkNet/starknet_call_self_function_git/Scarb.toml)
    Finished release target(s) in 54 seconds


Collected 2 test(s) from starknet_call_self_function package
Running 2 test(s) from tests/
[PASS] starknet_call_self_function_integrationtest::test_contract::test_increase_balance (gas: ~172)
[PASS] starknet_call_self_function_integrationtest::test_contract::test_cannot_increase_balance_with_zero_value (gas: ~105)
```

## Import an exist account

- Note: Use the appropriate `--type` for account import. Options:
  - oz: OpenZeppelin account
  - argent: Argent account
  - braavos: Braavos account

```sh
$ STARKNET_RPC="https://starknet-sepolia.g.alchemy.com/starknet/version/rpc/v0_7/<YOUR_ALCHEMY_API_KEY>" \
&& SMART_WALLET_ADDRESS="<YOUR_ACCOUNT_ADDRESS>" \
&& PRIVATE_KEY="<YOUR_ACCOUNT_PRIVATE_KEY>"

$ scarb run import --url "${STARKNET_RPC}" --address "${SMART_WALLET_ADDRESS}" --private-key "${PRIVATE_KEY}" --type argent

### Output:

command: account import
add_profile: Profile default successfully added to snfoundry.toml
```

## Declare the HelloStarknet contract

```sh
$ scarb run declare --contract-name HelloStarknet

### Output:

   Compiling snforge_scarb_plugin v0.33.0 (git+https://github.com/foundry-rs/starknet-foundry?tag=v0.33.0#221b1dbff42d650e9855afd4283508da8f8cacba)
    Finished `release` profile [optimized] target(s) in 0.41s
   Compiling starknet_call_self_function v0.1.0 (/Users/irara/MyGithub3/_home_of_tokens/StarkNet/starknet_call_self_function_git/Scarb.toml)
    Finished release target(s) in 4 seconds
[WARNING] Profile default does not exist in scarb, using 'release' profile.
command: declare
class_hash: 0x36521fde28cb438a8745cf65f427fbce9380e7fe64fa3394b42b2beae71c659
transaction_hash: 0x23d884bf1889cad1f436b3c1f634a5a0a3de59a6a35e876e0fd0c41d448ea0f

To see declaration details, visit:
class: https://sepolia.starkscan.co/class/0x36521fde28cb438a8745cf65f427fbce9380e7fe64fa3394b42b2beae71c659
transaction: https://sepolia.starkscan.co/tx/0x23d884bf1889cad1f436b3c1f634a5a0a3de59a6a35e876e0fd0c41d448ea0f
```

## Deploy the HelloStarknet contract

```sh
$ CLASS_HASH="0x36521fde28cb438a8745cf65f427fbce9380e7fe64fa3394b42b2beae71c659" \
&& SALT="0x0"

$ scarb run deploy --class-hash "${CLASS_HASH}" --salt "${SALT}"

### Output:

command: deploy
contract_address: 0x4f172aeeb9fafde0f5c957d83ff775aea6aa3362123b150a9f3a7356afde6ea
transaction_hash: 0x7fcf49c820375dd9284f164b2c655fe2039de3f3c5b03849f56c5545b230ed6

To see deployment details, visit:
contract: https://sepolia.starkscan.co/contract/0x4f172aeeb9fafde0f5c957d83ff775aea6aa3362123b150a9f3a7356afde6ea
transaction: https://sepolia.starkscan.co/tx/0x7fcf49c820375dd9284f164b2c655fe2039de3f3c5b03849f56c5545b230ed6
```

## Verify the HelloStarknet contract

```sh
$ CONTRACT_ADDRESS="0x4f172aeeb9fafde0f5c957d83ff775aea6aa3362123b150a9f3a7356afde6ea"

$ scarb run verify --contract-address "${CONTRACT_ADDRESS}" --network sepolia --contract-name HelloStarknet

### Output:

   Compiling snforge_scarb_plugin v0.33.0 (git+https://github.com/foundry-rs/starknet-foundry?tag=v0.33.0#221b1dbff42d650e9855afd4283508da8f8cacba)
    Finished `release` profile [optimized] target(s) in 0.38s
   Compiling starknet_call_self_function v0.1.0 (/Users/irara/MyGithub3/_home_of_tokens/StarkNet/starknet_call_self_function_git/Scarb.toml)
    Finished release target(s) in 4 seconds
[WARNING] Profile default does not exist in scarb, using 'release' profile.
You are about to submit the entire workspace's code to the third-party chosen verifier at walnut, and the code will be publicly available through walnut's APIs. Are you sure? (Y/n): Y
command: verify
message: "Contract verification has started. You can check the verification status at the following link: https://app.walnut.dev/verification/status/0286a546-6a8b-4202-8f78-c8c9d5470158"
```

## Declare the MyAccount contract via mainuser

```sh
$ sncast --profile default declare --fee-token eth --contract-name MyAccount

### Output:

   Compiling snforge_scarb_plugin v0.33.0 (git+https://github.com/foundry-rs/starknet-foundry?tag=v0.33.0#221b1dbff42d650e9855afd4283508da8f8cacba)
    Finished `release` profile [optimized] target(s) in 0.36s
   Compiling starknet_call_self_function v0.1.0 (/Users/irara/MyGithub3/_home_of_tokens/StarkNet/starknet_call_self_function_git/Scarb.toml)
    Finished release target(s) in 25 seconds
[WARNING] Profile default does not exist in scarb, using 'release' profile.
command: declare
class_hash: 0x161f8c256f4281a6f0a0ee2dfacd800c42dd9529691bec78c347820d1606fe0
transaction_hash: 0x1a01e1bb374d45b5524bd3bbbdb5d7935ac91c1c9910989d9235508dc44450d

To see declaration details, visit:
class: https://sepolia.starkscan.co/class/0x161f8c256f4281a6f0a0ee2dfacd800c42dd9529691bec78c347820d1606fe0
transaction: https://sepolia.starkscan.co/tx/0x1a01e1bb374d45b5524bd3bbbdb5d7935ac91c1c9910989d9235508dc44450d
```

## Create the MyAccount contract without fee

```sh
$ STARKNET_RPC="https://starknet-sepolia.g.alchemy.com/starknet/version/rpc/v0_7/<YOUR_ALCHEMY_API_KEY>" \
&& CLASS_HASH="0x161f8c256f4281a6f0a0ee2dfacd800c42dd9529691bec78c347820d1606fe0" \
&& SALT="0x0" && ACCOUNT_NAME="myaccount"

$ sncast account create --url "${STARKNET_RPC}" --class-hash "${CLASS_HASH}" --salt "${SALT}" --name "${ACCOUNT_NAME}" --add-profile "${ACCOUNT_NAME}" --type oz

### Output:

command: account create
add_profile: Profile myaccount successfully added to snfoundry.toml
address: 0x2e5f3bc7d6177f4298b95d44b0053f77b62a61a9f68564d7cfefcf939e8b829
max_fee: 766445170662
message: Account successfully created. Prefund generated address with at least <max_fee> STRK tokens or an equivalent amount of ETH tokens. It is good to send more in the case of higher demand.

To see account creation details, visit:
account: https://sepolia.starkscan.co/contract/0x2e5f3bc7d6177f4298b95d44b0053f77b62a61a9f68564d7cfefcf939e8b829
```

## Transfer 0.001 ETH from mainuser to myaccount

```sh
$ ETH_CONTRACT_ADDRESS="0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7" \
&& MY_ACCOUNT_ADDRESS="0x2e5f3bc7d6177f4298b95d44b0053f77b62a61a9f68564d7cfefcf939e8b829" \
&& AMOUNT="1000000000000000"

$ sncast --profile default invoke --fee-token eth --contract-address "${ETH_CONTRACT_ADDRESS}" --function transfer --arguments "${MY_ACCOUNT_ADDRESS}, ${AMOUNT}"

### Output:

command: invoke
transaction_hash: 0x776e4b45d9e82ebf90674e74f17b2deb567856e935e68c8faf56e932a50ce96

To see invocation details, visit:
transaction: https://sepolia.starkscan.co/tx/0x776e4b45d9e82ebf90674e74f17b2deb567856e935e68c8faf56e932a50ce96
```

## Deploy the MyAccount contract via myaccount

```sh
$ sncast account deploy --url "${STARKNET_RPC}" --fee-token eth --name ${ACCOUNT_NAME}

### Output:

command: account deploy
transaction_hash: 0x72859d15854dbef057f5b47b628d138806c40803242232c7c6a1ee6859ec542

To see invocation details, visit:
transaction: https://sepolia.starkscan.co/tx/0x72859d15854dbef057f5b47b628d138806c40803242232c7c6a1ee6859ec542
```

## Verify the MyAccount contract

```sh
$ sncast verify --verifier walnut --network sepolia --contract-address "${MY_ACCOUNT_ADDRESS}" --contract-name MyAccount

### Output:

   Compiling snforge_scarb_plugin v0.33.0 (git+https://github.com/foundry-rs/starknet-foundry?tag=v0.33.0#221b1dbff42d650e9855afd4283508da8f8cacba)
    Finished `release` profile [optimized] target(s) in 0.39s
   Compiling starknet_call_self_function v0.1.0 (/Users/irara/MyGithub3/_home_of_tokens/StarkNet/starknet_call_self_function_git/Scarb.toml)
    Finished release target(s) in 28 seconds
[WARNING] Profile myaccount does not exist in scarb, using 'release' profile.
You are about to submit the entire workspace's code to the third-party chosen verifier at walnut, and the code will be publicly available through walnut's APIs. Are you sure? (Y/n): Y
command: verify
message: "Contract verification has started. You can check the verification status at the following link: https://app.walnut.dev/verification/status/7579b1ba-c8ce-487b-97c2-340c46259630"
```

## Call myaccount self function

### Get custom_variable

```sh
$ sncast call --contract-address "${MY_ACCOUNT_ADDRESS}" --function get_custom_variable

### Output:

command: call
response: [0x0]
```

### Execute custom_function1 and check custom_variable

```sh
$ sncast --profile myaccount invoke --fee-token eth --contract-address "${MY_ACCOUNT_ADDRESS}" --function custom_function1

### Output:

command: invoke
transaction_hash: 0x30b2c070c5aa70a0acb410dd05260953676f249aa3660030933e40495d7f95b

To see invocation details, visit:
transaction: https://sepolia.starkscan.co/tx/0x30b2c070c5aa70a0acb410dd05260953676f249aa3660030933e40495d7f95b



$ sncast call --contract-address "${MY_ACCOUNT_ADDRESS}" --function get_custom_variable

### Output:

command: call
response: [0x1]
```

### ### Execute custom_function2 (failed) and check custom_variable

```sh
$ sncast --profile myaccount invoke --fee-token eth --contract-address "${MY_ACCOUNT_ADDRESS}" --function custom_function2

### Output:

command: invoke
error: Transaction execution error = TransactionExecutionErrorData { transaction_index: 0, execution_error: "Transaction execution has failed:\n0: Error in the called contract (contract address: 0x02e5f3bc7d6177f4298b95d44b0053f77b62a61a9f68564d7cfefcf939e8b829, class hash: 0x0161f8c256f4281a6f0a0ee2dfacd800c42dd9529691bec78c347820d1606fe0, selector: 0x015d40a3d6ca2ac30f4031e42be28da9b056fef9bb7357ac5e85627ee876e5ad):\nError at pc=0:4380:\nCairo traceback (most recent call last):\nUnknown location (pc=0:691)\nUnknown location (pc=0:3219)\n\n1: Error in the called contract (contract address: 0x02e5f3bc7d6177f4298b95d44b0053f77b62a61a9f68564d7cfefcf939e8b829, class hash: 0x0161f8c256f4281a6f0a0ee2dfacd800c42dd9529691bec78c347820d1606fe0, selector: 0x025565c07827f93212d4cb777b82f4725f915ad7cdee0c53935ce09f1be8820d):\nExecution failed. Failure reason: 0x4f6e6c792073657175656e6365722063616e2063616c6c ('Only sequencer can call').\n" }



$ sncast call --contract-address "${MY_ACCOUNT_ADDRESS}" --function get_custom_variable

### Output:

command: call
response: [0x1]
```

### ### Execute custom_function3 and check custom_variable

```sh
$ sncast --profile myaccount invoke --fee-token eth --contract-address "${MY_ACCOUNT_ADDRESS}" --function custom_function3

### Output:

command: invoke
transaction_hash: 0x55f185c5568b71341703d0bdb2942f5f4309c71b39897a9fe9a6f58274a9f0a

To see invocation details, visit:
transaction: https://sepolia.starkscan.co/tx/0x55f185c5568b71341703d0bdb2942f5f4309c71b39897a9fe9a6f58274a9f0a



$ sncast call --contract-address "${MY_ACCOUNT_ADDRESS}" --function get_custom_variable

### Output:

command: call
response: [0x3]
```
