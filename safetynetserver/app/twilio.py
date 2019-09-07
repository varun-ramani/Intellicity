from twilio.rest import Client

client = Client('ACafe80e4efd87b17c456eaf0b3616e6d7', 'c3c48f2b848b0f6e8483112c51fc969b')

message = client.messages.create(
    to='target_number',
    from_='twilion_number',
    body='An alert in your area was detected!')

print(message.sid)
