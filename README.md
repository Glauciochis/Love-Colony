# LÖVE Colony
This is an open source project aimed at creating a fully functional open-source engine for creating colony sim games in the style of Gnomoria, Dwarf Fortress, and RimWorld.
The engine is made up of the following services: ecs, event_handler, resources, and database. All game code are in the form of ECS systems thus you could use the engien without the colony-sim elements but it's made for colony sims.

This project is still in its infancy and thus only contains it's core engine and any things that are currently still being worked on.
At some point the creator (Iochi Glaucus, speaking in third person) plans to create a video series on how to use the engine and how it was coded which is a large element to the project.

## Services
### ECS
The core of the engine that handles entities, components, systems, and queries.
Entities are a list of components, components are data, systems do logic, queries handle interacting with entities based on their components.

### Event Handler
Handles events and similar functionality at the core of the engine. Events are used to trigger code anonymously, allowing anything to subscribe or emit events during the game.

### Resources
Manages resources (such as images, sprites, sounds, fonts, and so on) including loading them when they are needed and unloading them when they are no longer in use.

### Database
Handles data files such as items, races, tiles, and such, loading and unloading them when needed similar to resources however also dealing with registry (generating GUIDs) of data per save.
