# HideCollectedThings

## Description
HideCollectedThings is a World of Warcraft addon that hides already collected items from vendor windows, making it easier to see which items you still need to collect.

## Features
- Hides collected mounts, pets, toys, cosmetic items (transmog appearances), and ensemble sets from vendor windows
- Provides a toggle button to show/hide collected items
- Offers a slash command for quick toggling
- Maintains the default UI layout and functionality
- Compatible with other addons like CanIMogIt

## Installation
1. Download the latest version of the addon from [your download link or GitHub releases page]
2. Extract the folder into your World of Warcraft\_retail_\Interface\AddOns directory
3. Restart World of Warcraft or reload your UI

## Usage
The addon works automatically once installed. Here's how to use it:

1. Log into World of Warcraft
2. Open any vendor window that sells collectible items (mounts, pets, or toys)
3. By default, the addon will hide any items you've already collected
4. You'll only see items that you haven't collected yet, making it easier to identify what you still need

### Toggle Button
- Look for a button labeled "HCT" at the top of the vendor window
- Click this button to toggle between showing all items and hiding collected items

### Slash Command
- Type `/hct` in the chat window to toggle between showing all items and hiding collected items
- This command works anywhere, not just when a vendor window is open

### Tips:
- Use either the HCT toggle button or the `/hct` slash command to easily switch between viewing all items and only uncollected items
- The addon doesn't affect your ability to purchase items; it only changes what's displayed

## Configuration
Currently, there are no additional in-game configuration options. The addon works out of the box with the toggle button and slash command for basic control.

## Troubleshooting
If the addon doesn't seem to be working:
1. Ensure it's enabled in the AddOns menu at the character select screen
2. Check if the HCT button is visible in the vendor window
3. Try using the `/hct` slash command to toggle the addon
4. Try disabling other addons to check for conflicts
5. If issues persist, please report them on the GitHub issues page

### Debug Commands
- `/debugmount [itemLink]`: Debug command for testing mount detection and collection status
- `/debugpet [itemLink]`: Debug command for testing pet detection and collection status
- `/debugtoy [itemLink]`: Debug command for testing toy detection and collection status
- `/debugcosmetic [itemLink]`: Debug command for testing cosmetic item detection and collection status

These debug commands are useful for troubleshooting and understanding how the addon detects and processes different types of collectible items.

## Known Issues
None at the moment. If you encounter any issues, please report them on the GitHub issues page.

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments
- Thanks to all contributors and users for their support and feedback.

## Credits
Created by [lilshorty83]