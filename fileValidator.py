import time
import random
from pynput.mouse import Controller as MouseController
from pynput.keyboard import Controller as KeyboardController, Key

def move_mouse_and_type():
    """
    Simulates mouse movement and key presses to prevent the system from locking.
    """
    mouse = MouseController()
    keyboard = KeyboardController()

    try:
        # Move the mouse cursor slightly
        x, y = mouse.position
        dx = random.randint(-5, 5)  # Small random movement
        dy = random.randint(-5, 5)
        mouse.position = (x + dx, y + dy)

        # Press and release the Ctrl key
        keyboard.press(Key.ctrl)
        keyboard.release(Key.ctrl)

        print("Mouse moved and Ctrl key pressed.")  # Added print statement for logging

    except Exception as e:
        print(f"An error occurred: {e}") #error logging

def main():
    """
    Main function to run the script.  Added a try-except block to handle potential errors.
    """
    try:
        while True:
            move_mouse_and_type()
            time.sleep(60 * 5)  # Move every 5 minutes (adjust as needed)
    except KeyboardInterrupt:
        print("Script stopped by user.")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        print("Script stopped.")

if __name__ == "__main__":
    main()
