# SKPlayground

SKPlayground is a macOS application that enables developers to experiment with
various aspects of Apple's SpriteKit. The preliminary version will allow the
user to create, move, scale, and rotate sprites, as well as creating SKActions
to be applied to sprites.

1. Basic Concepts

    1. Arena

        The Arena is a SpriteKit SKScene on which the user can click and drag in various
        ways to manipulate game entities in ways similar to any other mouse-driven
        desktop app, for example (this is not an exhaustive list, but is here to indicate
        the kind of industry-standard mouse handling exhibited by the Arena):

            - Left-click creates a game entity, places a representative sprite in the
            scene at the location of the click, and selects the entity, that is, it
            sets the state of the new entity and its sprite to "selected".
            - Left-click-drag on a selected sprite moves all selected sprites in
            unison with the mouse movement
            - Left-click-drag on the background creates a selection marquee that grows and
            shrinks with the mouse movement. When the user releases the left mouse button,
            sprites contained by the rectangle are selected and sprites outside are deselected
            - Right-click on the background creates an Arena context menu with options for
            the type of entity to be created on left-click
            - Right-click on a sprite creates an Entity context menu with options for adding actions

    1. Dashboard

        The Dashboard is a SwiftUI View that shows information about the state of the Arena and
        the state of the selected entities. The Dashboard is composed of the MainView and the ToolsView.

        1. MainView

            The MainView will maintain a constantly updated display of the current mouse position
            in scene coordinates and the current mouse position in View coordinates. It will also have
            a set of buttons for controlling the activity in the Arena, such as a button to run all
            actions that have been defined for selected entities, and a button to pause/unpause the
            SpriteKit physics engine

        1. ToolsView

            The ToolsView is composed of multiple tabs that are shown and hidden depending on
            the state of the selected entities in the Arena, as follows

            1. Space Actions Tab

                The Space Actions Tab allows the user to create and manage an array of coordinate-space-related
                SKActions to be run when the user clicks the button in the MainView. Examples of
                coordinate-space-related SKActions include moving the sprite, scaling, the sprite, and
                rotating the sprite. At the bottom of the Space Actions Tab there will always be a button for
                creating a new action based on the other parameters in the tab.

                1. Components of the Space Actions Tab

                    1. Radio button set allowing the user to choose the type of action to create for the
                    entity. The choices will be move, scale, and rotate

                        1. Move

                            When the Move radio button is selected, the lower part of the tab will show
                            three sliders: an x-value, a y-value, and a duration.  The user will set these
                            and click the "new action" button, at which point an SKAction to move the sprite
                            will be created and stored for later, when the user clicks a button to tell the
                            app to run actions

                        1. Scale

                            When the Scale radio button is selected, there will again be three sliders: an
                            x-value, a y-value, and a duration, but for an SKAction to scale the sprite, same
                            as described above for "Move"

                        1. Rotate

                            When the Rotate radio button is selected, there will be only two sliders: a theta-value
                            and a duration. These will apply to an SKAction to rotate the sprite.

            1. Physics Actions Tab

                The Physics Actions Tab allows the user to create and manage an array of physics-related
                SKActions to be run when the user clicks the button in the MainView. Examples of
                physics-related SKActions include applying a force or applying torque.

            1. Physics Tab

                The Physics Tab allows the user to assign a SpriteKit physics body to physics-enabled game entities,
                and to manipulate the properties of that body


