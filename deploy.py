from solcx import compile_standard
import json
import os
from web3 import Web3
from dotenv import load_dotenv

load_dotenv()

with open("./simpleStorage.sol", r) as file:
    simple_storage_file = file.read()

compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"simpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection":{
                "*": {"*": ["abi", "metadata", "evm.bytecode","evm.sourceMap" ]}
            }
        },    
    },
    solc_version ="0.6.0",
)

with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)

bytecode = compiled_sol["contracts"]["simpleStorage.sol"]["simpleStorage"]["evm"]["bytecode"]["object"]
abi = compiled_sol["contracts"]["simpleStorage.sol"]["simpleStorage"]["abi"]

w3 = Web3(Web3.HTTPProvider("HTTP://127.0.0.1:7545"))
chain_id = 5777
my_address = "0x6ef57B6f52Fca1e087F7381366c81Cb64C945982"
private_key = os.getenv("PRIVATE_KEY")

simpleStorage= w3.eth.contract(abi=abi, bytecode=bytecode)

nonce = w3.eth.getTransactionCount(my_address)

transaction = simpleStorage.constructor().buildTransaction({"chainId": chain_id, "from": my_address, "nonce": nonce})
signed_transaction = w3.eth.account.sign_transaction(transaction, private_key = private_key)

tx_hash = w3.eth.send_raw_transaction(signed_transaction.rawTransaction)
tx_receipt =w3.eth.wait_for_transaction_receipt(tx_hash)

simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)
print(simple_storage.functions.retrieve().call())
store_transaction = simple_storage.functions.store(10).buildTransaction({
    "chainId": chain_id, "from": my_address, "nonce": nonce +1
})
signed_store_txn = w3.eth.account.sign_transaction(store_transaction, private_key = private_key)
send_store_txn = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt()
print(simple_storage.functions.retrieve().call())
