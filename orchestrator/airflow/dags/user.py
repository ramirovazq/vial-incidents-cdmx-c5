from airflow.sdk import asset, Asset, Context


@asset(
    schedule="@daily",
    uri="https://randomuser.me/api/"
)
def user(self) -> dict[str]:
    import requests

    # response = requests.get(self.uri)
    # print('>>>>>>> start <<<')
    # print('response: '+ str(response.json()))
    # print('>>>>>>> end <<<')
    # return response.json()
    RESPONSE_CONSTANT = {"results":[
        {"gender":"male","name":{"title":"Mr","first":"Salvador","last":"Montero"},
        "location":{"street":{"number":818,"name":"Calle de La Almudena"},"city":"Granada","state":"Castilla la Mancha","country":"Spain","postcode":74156,"coordinates":{"latitude":"-32.5902","longitude":"-71.3061"},"timezone":{"offset":"+8:00","description":"Beijing, Perth, Singapore, Hong Kong"}},
        "email":"salvador.montero@example.com",
        "login":{"uuid":"e9d1754b-0cd4-41d0-8aa3-16ca99ae001b","username":"redduck163","password":"ninja","salt":"cXZqeZdp","md5":"ed21b74dc398affa2f45cf25cae31cdb","sha1":"808700f880de20c84761cb7abc6083d36ff075d6","sha256":"4295084be07519029f39e2b5f80b4f48bc508435d85539b286fb48bbe6925373"},
        "dob":{"date":"1966-02-12T18:25:10.403Z","age":59},
        "registered":{"date":"2018-04-10T07:15:07.086Z","age":7},
        "phone":"965-680-007","cell":"634-148-488",
        "id":{"name":"DNI","value":"28751631-G"},
        "picture":{"large":"https://randomuser.me/api/portraits/men/66.jpg","medium":"https://randomuser.me/api/portraits/med/men/66.jpg","thumbnail":"https://randomuser.me/api/portraits/thumb/men/66.jpg"},"nat":"ES"}
        ],
        "info":{"seed":"667141d1c57cde4e","results":1,"page":1,"version":"1.4"}}
    return RESPONSE_CONSTANT


@asset(
    schedule=user
)
def user_location(user: Asset, context: Context) -> dict[str]:
    print("PINGPINGPING2")
    print('>>>>>>> start user.name <<<')
    print('user_name: '+ str(user.name) + '<<<')
    print('>>>>>>> end user.name <<<')
    user_data = context['ti'].xcom_pull(
        dag_id=user.name,
        task_ids=user.name,
        include_prior_dates=True,
    )
    print('>>>>>>> start user_data<<<')
    print('user_data: '+ str(user_data))
    print('>>>>>>> end user_data<<<')

    print('>>>>>>> start user_data name<<<')
    print(str(user_data[0]['results'][0]['name']))
    print('>>>>>>> end user_data name<<<')

    return user_data[0]['results'][0]['location']