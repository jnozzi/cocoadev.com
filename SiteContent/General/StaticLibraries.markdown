

This topic is for issues related to static libraries. 

Static libraries will not be linked if [[ZeroLink]] is enabled. If you get the following error:

<code>
[[ZeroLink]]: unknown symbol
</code>

you are probably building your target with [[ZeroLink]] enabled. See [[ZeroLink]] for details on how to turn this feature off.