---@module "game"



---@class IScene
-- `previous` - the previously active scene, or `false` if there was no previously active scene
-- `...` - additional arguments passed to `manager.enter` or `manager.push`
---@field enter fun(self: self, previous: self | false, ...)
---@field update fun(self: self, dt: number)
---@field keypressed fun(self: self, key: string)
---@field mousepressed fun(self: self, x: number, y: number, button: integer, isTouch: boolean, presses: integer)
-- `next` - the scene that will be active next
-- `...` - additional arguments passed to `manager.enter` or `manager.pop`
---@field leave fun(self: self, next: self, ...)
-- `next` - the scene that was pushed on top of this scene
-- `...` - additional arguments passed to `manager.push`
---@field pause fun(self: self, next: self, ...)
-- `previous` - the scene that was popped
-- `...` - additional arguments passed to `manager.pop`
-- Called when a scene is popped and this scene becomes active again.
---@field resume fun(self: self, previous: self, ...)
---@field draw fun(self: self)


---@class IModDefitinion
---@field id string
---@field name string
---@field modType "entity" | "map" 

---@class IMap: IModDefitinion
---@field modType "map"
---@field info table

---@class IEntity: Class
---@field protected position Vector [SERVER] Position in world space
---@field protected velocity Vector [SERVER] Current velocity
---@field protected angle Vector [SERVER] Pitch, yaw, roll
---@field protected entIndex number [SHARED] Unique entity index in the world
---@field protected className string [SHARED] Entity class name
---@field protected Update fun(self: self) [SHARED]
---@field protected Draw fun(self: self) [CLIENT]
---@field protected PhysicsUpdate fun(self: self, dt: number) [SERVER]

---@class IPlayerEntity: IEntity
---@field private onGround boolean
---@field private spriteData love.Image
---@field private CreateUserCommand fun(self: self): table [CLIENT] Sends user input to server
---@field private PerformUserCommand fun(self: self, cmd: table) [SERVER] Handle player input on server

---@class IWeapon: IEntity, IModDefitinion
---@field modType "entity"
---@field protected spriteData love.Image
---@field protected owner IPlayerEntity
---@field protected OnPrimaryFire? fun(self: self, origin: Vector) [SHARED]
---@field protected OnSecondaryFire? fun(self: self, origin: Vector) [SHARED]

---------------------------------------------------------------------------------
--- GUI
---@alias RGB table<integer, integer, integer>
--- 
---@class GuiElementProps
---@field private id? string
---@field parent? GuiElementProps
---@field width? number
---@field height? number
---@field visible? boolean
---@field opacity? number
---@field x? number
---@field y? number
---@field draw? fun(self: self)
---@field onClick? fun(self: self) | nil

---@class IGuiLabelProps: GuiElementProps
---@field text string
---@field font? love.Font
---@field color? RGB

---@class IGuiButtonProps: IGuiLabelProps
---@field leftPadding? number
---@field rightPadding? number
---@field topPadding? number
---@field bottomPadding? number
---@field icon? any | nil
---@field textColor? RGB
---@field backgroundColor? RGB
---@field cornerRadius? number
---@field hoverColor? RGB
---@field angle? number
---@field scale? number
---@field border? boolean
---@field borderColor? RGB
---@field borderWidth? number
---@field disabled? boolean
---@field private hoverCalled? boolean
---@field onClick fun(self: self)
---@field onHover? fun(self: self)

---------------------------------------------------------------------------------
--- Gamemodes
---@class IGM_Base: Class
---@field Init fun(self: self)
---@field OnMapStart fun(self: self)
---@field BeforeMapExit fun(self: self)
---@field OnPlayerEnter fun(self: self, peer: enet_peer)
---@field OnPlayerLeave fun(self: self, peer: enet_peer)
---@field OnPlayerSpawn fun(self: self, pl: IPlayerEntity)
---@field OnPlayerKill fun(self: self, target: IPlayerEntity, source: IPlayerEntity)
---@field OnDraw fun(self: self)
---@field OnUpdate fun(self: self)

---@class IGM_CTF: IGM_Base
---@field private FlagEnt IEntity
---@field OnFlagCapture fun(self: self, flagEnt: IEntity)
---@field OnFlagDrop fun(self: self, flagEnt: IEntity)
---@field OnFlagReset fun(self: self, flagEnt: IEntity)
---@field OnFlagScore fun(self: self, flagEnt: IEntity, pl: IPlayerEntity)

---------------------------------------------------------------------------------
--- ENET
---@class enet
---@field host_create fun(address?:string, maxClients?: integer): enet_host
---@field linked_version fun(): string
---@return enet

---@alias PEER_STATE "disconnected" | "connecting" | "acknowledging_connect" | "connection_pending" | "connection_succeeded" | "connected" | "disconnect_later" | "disconnecting" | "acknowledging_disconnect" | "zombie" | "unknown"
---@alias ENET_FLAG "reliable" | "unsequenced" | "unreliable"
---@alias ENET_EVENT_TYPE "connect" | "receive" | "disconnect"

---@class enet_host
---@field service fun(self: self, timeout?: number): enet_event | nil
---@field check_events fun(self: self, )
---@field connect fun(self: self, address: string, channel_count?: integer, data?: integer): enet_peer
---@field broadcast fun(self: self, message: string, channel?: integer, flag?: ENET_FLAG)
---@field channel_limit fun(self: self, limit: integer)
---@field destroy fun(self: self)
---@field peer_count fun(self: self): integer Maximum number of peers allowed
---@field get_peer fun(self: self, index: integer): enet_peer
---@field get_socket_address fun(self: self): string

---@class enet_peer
---@field send fun(self: self, data: string, channel?: integer, flag?: ENET_FLAG)
---@field receive fun(self: self): {data: string, channel: integer}
---@field disconnect fun(self: self, data?: integer)
---@field disconnect_now fun(self: self, data?: integer)
---@field disconnect_later fun(self: self, data?: integer)
---@field reset fun(self: self) Forcefully disconnects peer. The peer is not notified of the disconnection.
---@field ping fun(self: self) Send a ping request to peer, updates round_trip_time. This is called automatically at regular intervals.
---@field state fun(self: self): PEER_STATE
---@field index fun(self: self): integer Returns the index of the peer. All peers of an ENet host are kept in an array. This function finds and returns the index of the peer of its host structure.
---@field connect_id fun(self: self): integer Unique ID that was assigned to the connection.

---@class enet_event
---@field type ENET_EVENT_TYPE
---@field data string | number       -- datos recibidos, si hay
---@field peer enet_peer
---@field channel number
-- -@field reliable boolean
