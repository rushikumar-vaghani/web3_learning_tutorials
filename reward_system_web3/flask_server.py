import json
import os
from flask import Flask, request
from web3 import Web3
from employee_util import RewardSystem
from dotenv import load_dotenv

load_dotenv()
EMPLOYEE_SOL_FILE_PATH = os.environ["EMPLOYEE_SOL_FILE_PATH"]
MY_ADDRESS = os.environ["MY_ADDRESS"]
MY_PRIVATE_KEY = os.environ["MY_PRIVATE_KEY"]
GANACHE_CONN = os.environ["GANACHE_CONN"]
CHAIN_ID = int(os.environ["CHAIN_ID"])

reward_system_obj = None
reward_contract = None

app = Flask(__name__)
  
# The route() function of the Flask class is a decorator, 
# which tells the application which URL should call 
# the associated function.
@app.route('/')
def hello_world():
    return "Welcome to reward contract : {}".format(reward_contract)

@app.route('/AddEmployeeData', methods=['POST'])
def add_employee_data():
    content_type = request.headers.get('Content-Type')
    if (content_type == 'application/json'):
        json = request.json
        name = json["name"]
        designation = json["designation"]
        reward_amount = json["reward_amount"] if "reward_amount" in json else None
        reward_system_obj.add_employee_data(name, designation, reward_amount)
        return "Succesfully added employee data to contract : {}".format(reward_contract)
    else:
        return 'Content-Type not supported!'

@app.route('/UpdateEmployeeData', methods=['POST'])
def update_employee_data():
    content_type = request.headers.get('Content-Type')
    if (content_type == 'application/json'):
        json = request.json
        id = json["id"]
        name = json["name"] 
        designation = json["designation"]
        reward_system_obj.update_employee_data(id, name, designation)
        return "Succesfully updated employee data with id : {} to contract : {}".format(id, reward_contract)
    else:
        return 'Content-Type not supported!'

@app.route('/GetEmployeeData/<int:id>', methods=['GET'])
def get_employee_data(id):
    data = reward_contract.functions.getEmployeeData(id).call()
    response = app.response_class(
        response=json.dumps(data),
        status=200,
        mimetype='application/json'
    )
    return response

@app.route('/GetAllEmployeeData', methods=['GET'])
def get_all_employee_data():
    data = reward_contract.functions.getAllEmployeeData().call()
    response = app.response_class(
        response=json.dumps(data),
        status=200,
        mimetype='application/json'
    )
    return response

# main driver function
if __name__ == '__main__':

    # compile code and get abi, bytecode
    reward_system_obj = RewardSystem(GANACHE_CONN, CHAIN_ID, MY_ADDRESS, MY_PRIVATE_KEY, EMPLOYEE_SOL_FILE_PATH, "Employees")
    reward_system_obj.compile_sol_file()

    # Deploy contract
    reward_contract = reward_system_obj.deploye_contract()
    print(f'Contract deployed to: {reward_contract}\n')

    # run() method of Flask class runs the application 
    # on the local development server.
    app.run(port=5058)
