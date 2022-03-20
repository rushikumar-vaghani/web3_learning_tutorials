from web3 import Web3
from web3.providers.eth_tester import EthereumTesterProvider
from eth_tester import PyEVMBackend
from solcx import compile_source
import json

# python providing eth tester env for testing
#w3 = Web3(EthereumTesterProvider(PyEVMBackend()))
#print(w3.isConnected())

# connect to ganache node HTTP provider local one
# We have HTTP Provider, WS Provider or ICP local provider.
# Currently we are connectiong to HTTP provider and this provider will get from ganache
w3 = Web3(Web3.HTTPProvider('http://127.0.0.1:7545'))
print(w3.api)
print(w3.clientVersion)
print(w3.isConnected())

# How to get latest transaction details.
latest_block = w3.eth.get_block('latest')
print(latest_block)

# How to apply filter
latest_block = w3.eth.filter('latest')
print(latest_block)

pending_block = w3.eth.filter('pending')
print(pending_block)

filter_block = w3.eth.filter({'fromBlock':0, 'toBlock':1})
print(filter_block)

# please refer for more details https://web3py.readthedocs.io/en/stable/overview.html#api
# web3 api to fetch all data
balance_in_wei = w3.eth.get_balance('0x8d6E7b1D1cbBFf2F1Bdd0D5de8AD20C60A96d1Ff')
balance_in_ether = w3.fromWei(balance_in_wei, 'ether')
print("Balance in wei : {}".format(balance_in_wei))
print("Balance in ether : {}".format(balance_in_ether))

# How to compile code of solidity in python
def compile_source_file(file_path):
	with open(file_path, 'r') as f:
		source = f.read()
	return compile_source(source)

# How to deploy sol compiled code
def deploy_contract(w3, contract_interface):
	tx_hash  = w3.eth.contract(abi = contract_interface['abi'], bytecode = contract_interface['bin']).constructor().transact()
	contract_address = w3.eth.get_transaction_receipt(tx_hash)['contractAddress']
	return contract_address

# Read compile file code for abi
def read_compile_source_file(compile_file_path):
	with open(compile_file_path, 'r') as file:
		data = json.load(file)
	return data

#compile_source_file_path = '/Users/web3_learning_tutorials/contract/contracts/store_contract.sol'
#compile_file_path = '/Users/web3_learning_tutorials/contract/build/contracts/testContract.json'
#compile_sol = compile_source_file(compile_source_file_path)

#contract_id, contract_interface = compile_sol.popitem()
#print(contract_id)
#print(contract_interface)
#print(type(contract_interface))

#address = deploy_contract(w3, contract_interface)
#address = '0x1421788284e872b773B0d426f9C9905084625c25'
#contract_interface = read_compile_source_file(compile_file_path)
#print(f'Contract deployed to: {address}\n')

#test_contract = w3.eth.contract(address=address, abi=contract_interface['abi'])
#gas_estimate = test_contract.functions.setVar(190).estimateGas()
#print(f'Gas estimate to transact with setP: {gas_estimate}')

# for set call (function which is not returning any value) we have to do transact()
#tx_hash = test_contract.functions.setVar(190).transact()
#receipt_add = w3.eth.get_transaction_receipt(tx_hash)
#print(f'Transaction Receipt: {receipt_add}')
#receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
#print("Receipt data : %s" % receipt)

# For get call we have to make call() 
#p_val = test_contract.functions.getVar().call()
# alternate we can use caller instead of functions
# p_value = test_contract.caller().getVar()
#print("Value of p in contract : %s" % p_val)


