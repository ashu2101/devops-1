from flask import Flask

# Create an instance of the Flask application.
# The __name__ argument helps Flask locate resources.
app = Flask(__name__)

# Define a route for the root URL ('/').
# When a user accesses the root of your web application,
# this function will be executed.
@app.route('/')
def hello_world():
    """
    This function returns a simple "Hello World!" message.
    """
    return 'Hello World!'

# This block ensures the Flask application runs only when the script is executed directly (not imported).
if __name__ == '__main__':
    # Run the Flask application.
    # debug=True enables debug mode, which provides helpful error messages and auto-reloads the server
    # when code changes. It should be set to False in a production environment.
    # host='0.0.0.0' makes the server accessible from any IP address.
    # port=80 specifies that the application should listen on port 80,
    # which is the default HTTP port.
    # Note: Running on port 80 often requires administrator/root privileges
    # (e.g., 'sudo python your_app_name.py' on Linux/macOS, or running as Administrator on Windows).
    app.run(debug=True, host='0.0.0.0', port=80)
