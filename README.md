# Plants: Bomb Squad

## APK Download and instructions
To avoid the mess of downloading/installing dependencies, we've provided an apk:
https://drive.google.com/file/d/1LkxOVvRNoDQaFeUHpRrggOHeBw-CUS1E/view?usp=sharing
1. Download the apk on an android phone
2. When downloaded, navigate to Downloads folder and tap on the apk. Tap 'yes' when prompted.
3. Your apk will begin installing. At login, use the username 'bombsquad'. 

## Setting Up Front End
### Starting the Front End
With flutter installed: 
1. Navigate to `src/app`
2. Run `flutter pub get` to retrieve dependencies
3. Start up android emulator via VSCode
4. Navigate to the "Run and debug" menu, select the launch option called "Plant app"
## Setting Up Back end
### Virtual Environment
1. Navigate to `src/server`
2. Run the following command to create the environment: `python3 -m venv .venv`
3. Access the virtual environment:
    Unix / Mac OS X: `source .venv/bin/activate`
    Windows w/ Command Prompt: `path\to\venv\Scripts\activate.bat`
4. Install the packages: `pip3 install -r requirements.txt`

In the future, when you have already installed the packages and created the enivironment,
all you will need to do is start the virtual environment.

### Setting Up MySQL (Locally)
1. Install a local MySQL server on your local machine: https://www.mysql.com/downloads/
2. Install MySQLWorkbench: https://www.mysql.com/products/workbench/
3. Start the MySQL server
4. Connect to your MySQL server from MySQLWorkbench.
5. Create the plants database: `CREATE DATABASE plants`
6. Navigate to `src/server/scripts/sql` and find `/create_combined.sql` and `/insert_combined.sql`
7. Copy the contents of `/create_combined.sql` and execute all commands from MySQLWorkbench to generate the schema.
8. If you desire some dummy data to use, run the contents of `/insert_combined.sql` as seen in step 7.

### Starting The Back End Server
1. Navigate to `src/server`
2. Access the virtual environment. See above for more information.
3. Run `python3 app.py`
4. Navigate to `http://127.0.0.1:5000`

## Setting Up the Moisture Sensor
### ESP/Arduino
1. Store a h file "secrets.h" with a Wifi SSID, PASSWORD and APIKEY in hardware/esp
2. Using Arduino IDE upload the files hardware/arduino/arduino.ino, hardware/esp/esp.ino and hardware/esp/secrets.h to the Arduino and ESP microcontroller respectively. Note: the plantId for the moisture sensor can be changes in esp.ino.
