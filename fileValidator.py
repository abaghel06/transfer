def fileValidator(fileNames, identifiers):
    for file in fileNames:
        found = false
        for identifier in indentifiers:
            if identifier in file:
                found=True
                break
        if not found:
            raise ValueError(f"Filename '{file}' doesn't match any unique identifiers")

        print("All files match")


try:
    fileValidator(fileList, idList)
except ValueError as e:
          print(f"Error: {e}")
