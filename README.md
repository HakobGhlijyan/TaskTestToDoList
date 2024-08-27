
# TaskTestToDoList
## SwiftUI app
In screen folder enable video


# It is necessary to develop a simple application for maintaining a to-do list (ToDo List) with the ability to add, edit, delete tasks.
## Requirements:
### 1. Task List:
- Display the task list on the home screen.
   - The task must contain the name, description, creation date and status (completed/not completed).
   - The ability to add a new task.
   - The ability to edit an existing task.
   - The ability to delete a task.
### 2. Loading the task list from the dump json api: https://dummyjson.com/todos . The first time the application is launched, it must load the task list from the specified json api.  
 
### 3. Multithreading:
   - The processing of creating, uploading, editing and deleting tasks should be performed in the background using GCD or NSOperation.
   - The interface should not be blocked when performing operations.
### 4. SwiftData:
- Task data should be saved in CoreData.
   - The application must correctly restore data when it is restarted.


 
## Необходимо разработать простое приложение для ведения списка дел (ToDo List) с возможностью добавления, редактирования, удаления задач.
Требования:
 ### 1. Список задач:
   - Отображение списка задач на главном экране.
   - Задача должна содержать название, описание, дату создания и статус (выполнена/не выполнена).
   - Возможность добавления новой задачи.
   - Возможность редактирования существующей задачи.
   - Возможность удаления задачи.
### 2. Загрузка списка задач из dump json api: https://dummyjson.com/todos. При первом запуске приложение должно загрузить список задач из указанного json api.  
 
### 3. Многопоточность:
   - Обработка создания, загрузки, редактирования и удаления задач должна выполняться в фоновом потоке с использованием GCD или NSOperation.
   - Интерфейс не должен блокироваться при выполнении операций.
### 4. CoreData:
   - Данные о задачах должны сохраняться в CoreData.
   - Приложение должно корректно восстанавливать данные при повторном запуске.




<div id="stat0" align="center">
  <img src="https://github.com/HakobGhlijyan/TaskTestToDoList/blob/main/Screen/ph1.png" width="400"/>
  <img src="https://github.com/HakobGhlijyan/TaskTestToDoList/blob/main/Screen/ph2.png" width="400"/>
  <img src="https://github.com/HakobGhlijyan/TaskTestToDoList/blob/main/Screen/ph3.png" width="400"/>
  <img src="https://github.com/HakobGhlijyan/TaskTestToDoList/blob/main/Screen/ph4.png" width="400"/>
</div>

<div id="stat0" align="center">
  <img src="https://github.com/HakobGhlijyan/TaskTestToDoList/blob/main/Screen/v1.gif" width="1200"/>
  <img src="https://github.com/HakobGhlijyan/TaskTestToDoList/blob/main/Screen/v2.gif" width="1200"/
</div>
