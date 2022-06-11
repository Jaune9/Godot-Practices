# Practice: Fortune Cookies

We have a *FortuneCookie* scene that can display sentences nicely when pressing a button.

![](images/practice-fortune-cookie.gif)

Unfortunately, right now, it doesn't have anything to show!

Open the *Fortune cookie* practice in the *Practices* dock to get started.

There are two parts to this practice:

1. You will first create a resource file and give it to the FortuneCookie node.
2. Then come on your odds a function to get a random line to the book script and call it from the fortune cookie script.

Open the `FortuneCookie.gd` script in the FileSystem dock.

Select the fortune cookie node and the scene and look at the inspector. It expects a book resource. You will need to create a new Book resource file and give it several `lines` of text to display.

Then, you'll need to code a function named get_random_line() in the Book.gd script. The function should return a random value from the `Book.lines` array. You will need to call that function from the FortuneCookie.gd script.

Here are three lines that you can write in your Book resource:

- It's not a bug. It's an undocumented feature!
- Programming is the process of putting new bugs in.
- Computers are useless. They can only give you answers.

# Practice: The item resource

In this practice, you will create a couple of resource files and give them to an inventory to display.

![](images/practice-the-item-resource.png)

Resources are a great fit to store data for items and equipment.

To get started, open the practice named *The item resource* in the practices dock.

You will first need to complete the InventoryItem script. You need to add four exported variables to the resource script. You'll find the details in the InventoryItem.gd file.

Then, create at least three InventoryItem resource files and fill in their properties. You can use images in the `assets/` neighbor directory for the icon textures.

Finally, add all resource files to the InventoryItems node's Items property in the Inspector.

The Items property is an exported array. Click the button that says *Array (Size 0)* next to the property label to edit it.

![](images/practice-array-size-label.png)

Click the field next to Size and set the number to match the number of resources you created. 

![](images/practice-setting-array-size-inspector.png)

You can now drag and drop each of your tres files onto one of the created slots. Be careful not to leave any empty slots, or you will get errors.

![](images/practice-setting-array-resources-inspector.png)

# Practice: Saving the inventory

In this practice, you will write code to save and load an inventory from the Inventory resource.

Open the practice named *Saving the inventory* in the *Practices* dock.

We prepared a scene with the inventory's interface. It has an `Inventory` resource attached to it, and when you run the scene, the resource's contents show up.

![](images/practice-inventory-save.png)

There are also several buttons to save the inventory, add an item, and remove an item. But there's an issue: the `Inventory.save()` function does not exist.

Your task is to open the `Inventory.gd` script and add the missing function.

# Practice: Equipping weapons


