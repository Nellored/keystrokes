# KeyStrokesNew (console command)
**Adds new key in KeyStrokes**
| Parameter | Description            | Type    | Values |
|-----------|------------------------|---------|-------------------------------------------|
| text      | What displayed on key  | string  |                                           |
| key       | KeyID which you click  | integer | https://wiki.facepunch.com/gmod/Enums/KEY |
| line      | Y Position             | integer | 0,1,2,3,4,5,6,7,8,9,etc.                  |
| pos       | X Position             | integer | 0,1,2,3,4,5,6,7,8,9,etc.                  |
| size      | Which size will be key | string  | small, medium, big, bigger                |

![sizes](https://user-images.githubusercontent.com/55703681/197153092-b5beb487-912c-4f16-a2f8-1ad0c4c9bf0c.png)

**Example**

`KeyStrokesNew W 33 1 1 small` 

**Description**

| Parameter | Value |
|-----------|-------|
| text      | W     |
| key       | 33    |
| line      | 1     |
| pos       | 1     |
| size      | small |

![изображение](https://user-images.githubusercontent.com/55703681/197146997-37e2a503-5e3a-407f-b820-0eca0ad816ec.png)

# KeyStrokesDelete (console command)
**Deletes key in KeyStrokes**
| Parameter | Description            | Type    |
|-----------|------------------------|---------|
| text      | What displayed on key  | string  |
| key       | KeyID which you click  | integer |

**Example**

`KeyStrokesDelete W 33` 

**Description**

| Parameter | Value |
|-----------|-------|
| text      | W     |
| key       | 33    |

![изображение](https://user-images.githubusercontent.com/55703681/197153022-10111a09-8b1f-4145-9c7c-a61f72845bd8.png)
