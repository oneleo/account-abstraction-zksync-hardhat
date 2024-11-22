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
