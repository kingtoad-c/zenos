import os
import subprocess

# Get the current directory of the script
script_directory = os.path.dirname(os.path.realpath(__file__))

# Path to the zenos.sh script (in the same directory as the Python script)
ZENOS_SCRIPT = os.path.join(script_directory, "zenos.sh")

# Check if the zenos.sh script exists
if not os.path.isfile(ZENOS_SCRIPT):
    print(f"Error: {ZENOS_SCRIPT} does not exist.")
    exit(1)

# Define the service content for systemd
service_content = f"""
[Unit]
Description=Run zenos.sh script on boot
After=network.target

[Service]
ExecStart={ZENOS_SCRIPT}
Restart=always
User=root
Group=root

[Install]
WantedBy=multi-user.target
"""

# Path to the systemd service file
service_file = "/etc/systemd/system/zenos.service"

# Write the service file to disk
try:
    with open(service_file, 'w') as f:
        f.write(service_content)
    print(f"Service file created at {service_file}")
except Exception as e:
    print(f"Error writing service file: {e}")
    exit(1)

# Enable and start the systemd service
try:
    subprocess.run(['systemctl', 'daemon-reload'], check=True)  # Reload systemd
    subprocess.run(['systemctl', 'enable', 'zenos.service'], check=True)  # Enable the service
    subprocess.run(['systemctl', 'start', 'zenos.service'], check=True)  # Start the service immediately
    print("zenos.sh is now set to run on boot using systemd.")
except subprocess.CalledProcessError as e:
    print(f"Error enabling or starting the service: {e}")
    exit(1)
