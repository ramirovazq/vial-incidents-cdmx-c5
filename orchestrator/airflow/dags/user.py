from airflow.sdk import asset, Asset, Context


@asset(
    schedule="@daily",
    uri="https://randomuser.me/api/"
)
def user(self) -> dict[str]:
    import requests

    response = requests.get(self.uri)
    print('>>>>>>> start <<<')
    print('response: '+ str(response.json()))
    print('>>>>>>> end <<<')
    return response.json()

@asset(
    schedule=user
)
def user_location(user: Asset, context: Context) -> dict[str]:
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