# eta

PLSQL ETA package - computes time remaining

## PL/SQL API

### `eta.set_total_work`

Sets total count of work units **total_work** that have to be processed and stores timestamp of call as start of processing timestamp.

**Parameters**

- **total_work** - count of work units

### `eta.get - overload 1`

Computes ETA interval based on total work and start timestamp set by [`eta.set_total_work`](#eta-set.total-work) and value of **sofar** paramter - count of items processed so far.

**Paramters**

- **sofar** - count of items processed so far

### `eta.get - overload 2`

Get ETA interval computed from start timestamp **started_at**, total count work of work items **total_work** and count of units processed so far **sofar**.

**Parameters**

- **started_at** - timestamp of start of the processing
- **total_work** - total count of work items to be processed
- **sofar** - count of work items already processed 

### `eta.get_formatted - overload 1`

Formats ETA interval as string based on total work and start timestamp set by [`eta.set_total_work`](#eta-set.total-work) and **sofar** with **days** position for days and **fractions** positions for fractions of second.

**Parameters**

- **sofar** - count of work items already processed
- **days** - days positions
- **fractions** - fractions positions

### `eta.get_formatted - overload 2`

Formats ETA interval as string computed from start timestamp **started_at**, total count of work items **total_work** and count of units processed so far **sofar** with **days** position for days and **fractions** positions for fractions of second.

**Parameters**

- **started_at** - timestamp of start of the processing
- **total_work** - total count of work items to be processed
- **sofar** - count of work items already processed
- **days** - days positions
- **fractions** - fractions positions

## Package scripts

Connect as DBA or privileged user (`SYS` is the best) and

### create

Create schema for **eta** as configured in `package.sql`

```
SQL> @create configured
```

Or create in interactive mode 

```
SQL> @create manual
```

### grant

Or you may wish to install **eta** in already existing schema. Then use the `grant.sql` script to grant privileges required by **eta** package.

```
SQL> @grant <packageSchema>
```

### drop

Again either configured or manual. **And it drops cascade. So be carefull. You have been warned**

```
SQL> @drop configured
```
or
```
SQL> @drop manual
```

## Install scripts

You can install either from some privileged deployer user or from within "target" schema.

### set_current_schema

Use this script to change `current_schema`

```
SQL> @set_current_schema <target_schema>
```

### install

Installs module in `current_schema`. (see `set_current_schema`). Can be installed as 

- **public** - grants required privileges on module API to `PUBLIC` (see `/module/api/grant_public.sql`)

```
SQL> @install public
```

- **peer** - sometimes you may want to use package only by schema, where it is deployed - then install it as **peer** package

```
SQL> @install peer
```

### uninstall

Drops all objects created by install.

```
SQL> @uninstall
```

## Use eta from different schemas

When you want to use **eta** from other schemas, you have basically 2 options
- either reference objects granted to `PUBLIC` with qualified name (`<schema>.<object>`)
- or create synonyms and simplify everything (upgrades, move to other schema, use other eta package, ...)

These scripts will help you with latter, by either creating or dropping synonyms for **eta** package API in that schema.

### set_dependency_ref_owner

Creates depenency from reference owner.

```
SQL> conn <some_schema>
SQL> @set_dependency_ref_owner  <schema_where_eta_is_installed>
```

### unset_dependency_ref_owner

Removes depenency from reference owner.

```
SQL> conn <some_schema>
SQL> @unset_dependency_ref_owner  <schema_where_eta_is_installed>
```
