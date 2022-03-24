import os
from dotenv import load_dotenv
from employee_util import RewardSystem

load_dotenv()
EMPLOYEE_SOL_FILE_PATH = os.environ["EMPLOYEE_SOL_FILE_PATH"]
MY_ADDRESS = os.environ["MY_ADDRESS"]
MY_PRIVATE_KEY = os.environ["MY_PRIVATE_KEY"]
GANACHE_CONN = os.environ["GANACHE_CONN"]
CHAIN_ID = int(os.environ["CHAIN_ID"])

reward_system = RewardSystem(GANACHE_CONN, CHAIN_ID, MY_ADDRESS, MY_PRIVATE_KEY, EMPLOYEE_SOL_FILE_PATH, "Employees")
reward_system.compile_sol_file()

# Deploy contract
reward_contract = reward_system.deploye_contract()
print(f'Contract deployed to: {reward_contract}\n')

reward_system.add_employee_data("John", "Engineer")
latestData = reward_contract.functions.getEmployeeData(0).call()
print(latestData)
