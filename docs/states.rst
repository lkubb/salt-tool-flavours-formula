Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``tool_flavours``
~~~~~~~~~~~~~~~~~
*Meta-state*.

Performs all operations described in this formula according to the specified configuration.


``tool_flavours.package``
~~~~~~~~~~~~~~~~~~~~~~~~~
Installs the Flavours package only.


``tool_flavours.xdg``
~~~~~~~~~~~~~~~~~~~~~
Ensures Flavours adheres to the XDG spec
as best as possible for all managed users.
Has a dependency on `tool_flavours.package`_.


``tool_flavours.sources``
~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_flavours.config``
~~~~~~~~~~~~~~~~~~~~~~~~
Manages the Flavours package configuration by

* recursively syncing from a dotfiles repo

Has a dependency on `tool_flavours.package`_.


``tool_flavours.completions``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Installs flavours completions for all managed users.
Has a dependency on `tool_flavours.package`_.


``tool_flavours.clean``
~~~~~~~~~~~~~~~~~~~~~~~
*Meta-state*.

Undoes everything performed in the ``tool_flavours`` meta-state
in reverse order.


``tool_flavours.package.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the Flavours package.
Has a dependency on `tool_flavours.config.clean`_.


``tool_flavours.xdg.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes Flavours XDG compatibility crutches for all managed users.


``tool_flavours.config.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the configuration of the Flavours package.


``tool_flavours.completions.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes flavours completions for all managed users.


