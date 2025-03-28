Erlang/Elixir  EIMS-XMPP library
==========================

[![CI](https://github.com/processone/xmpp/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/processone/xmpp/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/processone/xmpp/badge.svg?branch=master&service=github)](https://coveralls.io/github/processone/xmpp?branch=master)
[![Hex version](https://img.shields.io/hexpm/v/xmpp.svg "Hex version")](https://hex.pm/packages/xmpp)

The library provides comprehensive representation
of standard XMPP elements and additional EIMS elements as well as tools to work with them. Every such element
is represented by an Erlang record. Most of the library's code is auto generated
and thus considered to be bug free and efficient.

The approach is very similar to [ASN.1](https://en.wikipedia.org/wiki/Abstract_Syntax_Notation_One),
[Google Protocol Buffers](https://en.wikipedia.org/wiki/Protocol_Buffers) or
[Apache Thrift](https://en.wikipedia.org/wiki/Apache_Thrift): an XML element
is transformed into internal language structure (an Erlang record in our case) - the process
known as "decoding". During decoding, validation is also performed, thus well-typed
structures are generated, potentially decreasing bugs related to handcrafted parsing.
A reverse process known as "encoding" is applied for transforming an Erlang record
into an XML element.

The library should be used along with [fast_xml](https://github.com/processone/fast_xml)
library, because it is only able to decode from and encode to structures
generated by that library (that is, `xmlel()` elements).

**Table of Contents**:
1. [Status](#status)
2. [Compiling](#compiling)
3. [API](#api)
4. [Usage](#usage)
   1. [Initialization and header files](#initialization-and-header-files)
   2. [XMPP elements](#xmpp-elements)
   3. [Decoding and encoding](#decoding-and-encoding)
   4. [Stanzas](#stanzas)
      1. [Common fields](#common-fields)
      2. [Constructing stanza responses](#constructing-stanza-responses)
   5. [Error elements](#error-elements)
   6. [Text elements](#text-elements)
   7. [Pretty printer](#pretty-printer)
   8. [Namespaces](#namespaces)
   9. [XMPP addresses](#xmpp-addresses)
   10. [Language translation](#language-translation)
5. [Supported XMPP elements](#supported-xmpp-elements)

# Status

The library is considered as production ready and has been used in
[ejabberd XMPP server](https://www.process-one.net/en/ejabberd) since version 16.12.
However, the API is quite unstable so far and incompatibilities may be introduced
from release to release. The stable API will be denoted by `2.x` tag in the future.

# Dependency

You need at least Erlang OTP 19.0.

# Compiling

As usual, the following commands are used to obtain and compile the library:
```
$ git clone https://github.com/eimsp/eims-xmpp.git
$ cd xmpp
$ make
```

# API

The full API is documented in [doc/API.md](doc/API.md)

# Usage

## Initialization and header files

Before calling any function from the library, `xmpp` application should be
started.

Although there are several header files which a developer might find useful
to look into, they should **not** be included directly in the code. Only
[include/xmpphrl](include/xmpp.hrl) file should be included, because
it already includes all needed headers and also defines some useful macros.
So the typical code should look like:
```erlang
%% file: foo.erl
-module(foo).
-include_lib("xmpp/include/xmpp.hrl").
...
start() ->
    application:start(xmpp),
    ...
```

## XMPP elements

All XMPP elements (records) are defined in [include/xmpp_codec.hrl](include/xmpp_codec.hrl)
file. For convenience, every record has the corresponding type spec.
There is also predefined `xmpp_element()` type which is a container for all
defined record types: so sometimes we will refer to an arbitrary XMPP element as
`xmpp_element()` in the rest of this document. These records are generated
automatically by
[XML generator](https://github.com/processone/fast_xml/blob/master/src/fxml_gen.erl)
from specification file
[specs/xmpp_codec.spec](specs/xmpp_codec.spec).
The specification file contains information about XML elements
defined within XMPP related namespace.

> **TODO**: writing specs for new elements will be documented later. For now
> you can learn by example: pick up a spec of any element which is very close
> to the one you want to add a spec for and use it as a pattern

> **WARNING**: you should **not** include `xmpp_codec.hrl` in your erlang code.
> Include `xmpp.hrl` instead. `xmpp_codec.hrl` should be only used to
> consult definitions of existing XMPP elements.

## Decoding and encoding

Once an `xmlel()` element is obtained (either using `fxml_stream:parse_element/1`
function or by any other means), it can be decoded using either [decode/1](doc/API.md#decode1)
or [decode/3](doc/API.md#decode3) functions. The result will be an XMPP element. Note
that decoding might fail if there is no known XMPP element for the provided
`xmlel()` element, or `xmlel()` is invalid, so you should call these functions
inside `try ... catch`. Exceptions returned during decoding can be formatted using
[format_error/1](doc/API.md#format_error1) or [io_format_error/1](doc/API.md#io_format_error1)
functions.

**Example**:
```erlang
handle(#iq{type = get, sub_els = [El]} = IQ) ->
    try xmpp:decode(El) of
        Pkt -> handle_iq_child_element(Pkt)
    catch _:{xmpp_codec, Reason} ->
        Txt = xmpp:format_error(Reason),
	io:format("iq has malformed child element: ~s", [Txt]),
	handle_iq_with_malformed_child_element(IQ)
    end.
```

[encode/1](doc/API.md#encode1) and [encode/2](doc/API.md#encode2) functions can be used for reverse
transformation, i.e. to encode an XMPP element into `xmlel()` element.
Encoding would never fail as long as provided XMPP element is valid.

## Stanzas

Amongst all XMPP elements defined in the library, the most notable ones
are stanzas: `message()`, `presence()` and `iq()` elements. A large part of `xmpp`
module deals with stanzas.

### Common fields

Records of all stanzas have several common fields:
`id`, `type`, `lang`, `from`, `to`, `sub_els` and `meta`. Although it's
acceptable to manipulate with these fields directly (which is useful in
pattern matching, for example), `xmpp` module provides several functions
to work with them:
- `id`: [get_id/1](doc/API.md#get_id1) and [set_id/2](doc/API.md#set_id2) can be used
- `type`: [get_type/1](doc/API.md#get_type1) and [set_type/2](doc/API.md#set_type2) can be used
- `lang`: [get_lang/1](doc/API.md#get_lang1) and [set_lang/2](doc/API.md#set_lang2) can be used
- `from` and `to`: [get_from/1](doc/API.md#get_from1), [get_to/1](doc/API.md#get_to1),
  [set_from/2](doc/API.md#set_from2), [set_to/2](doc/API.md#set_to2) and [set_from_to/3](doc/API.md#set_from_to3)
  can be used
- `sub_els`: [get_els/1](doc/API.md#get_els1) and [set_els/2](doc/API.md#set_els2) can be used;
  additional functions to work with subtags directly are:
  [set_subtag/2](doc/API.md#set_subtag2), [get_subtag/2](doc/API.md#get_subtag2),
  [get_subtags/2](doc/API.md#get_subtags2), [try_subtag/2](doc/API.md#try_subtag2),
  [try_subtags/2](doc/API.md#try_subtags2), [remove_subtag/2](doc/API.md#remove_subtag2),
  [has_subtag/2](doc/API.md#has_subtag2), and [append_subtags/2](doc/API.md#append_subtags2).
- `meta`: this field is intended for attaching arbitrary Erlang terms to
  stanzas; the field is represented by a `map()` and can be manipulated
  using standard [maps](http://erlang.org/doc/man/maps.html) module, but
  also using the following functions: [get_meta/1](doc/API.md#get_meta1),
  [get_meta/2](doc/API.md#get_meta2), [get_meta/3](doc/API.md#get_meta3), [set_meta/2](doc/API.md#set_meta2),
  [put_meta/3](doc/API.md#put_meta3), [update_meta/3](doc/API.md#update_meta3) and
  [del_meta/2](doc/API.md#del_meta2)

### Constructing stanza responses

For creating `iq()` replies the following functions exist:
[make_iq_result/1](doc/API.md#make_iq_result1) and [make_iq_result/2](doc/API.md#make_iq_result2).

These two functions are `iq()` specific and create `iq()` elements of type
`result` only. To create an error response from an arbitrary stanza
(including `iq()`) [make_error/2](doc/API.md#make_error2) function can be used.

## Error elements

A series of functions is provided by `xmpp` module for constructing
`stanza_error()` or `stream_error()` elements. To construct `stanza_error()`
elements the functions with `err_` prefix can be used, such as
[err_bad_request/0](doc/API.md#err_bad_request0) or
[err_internal_server_error/2](doc/API.md#err_internal_server_error2).
To construct `stream_error()` elements the functions with `serr_` prefix
can be used, such as [serr_not_well_formed/0](doc/API.md#serr_not_well_formed0) or
[serr_invalid_from/2](doc/API.md#serr_invalid_from2).

## Text elements

The text element is represented by `#text{}` record (of `text()` type).
Some record fields, such as `#message.body` or `#presence.status`,
contain a list of text elements (i.e. `[text()]`).
To avoid writing a lot of extracting code the following functions can be used
to manipulate with `text()` elements: [get_text/1](doc/API.md#get_text1),
[get_text/2](doc/API.md#get_text2), [mk_text/1](doc/API.md#mk_text1) and [mk_text/2](doc/API.md#mk_text2).

## Pretty printer

For pretty printing of XMPP elements (for example, for dumping elements in
the log in a more readable form), [pp/1](doc/API.md#pp1) function can be used.

## Namespaces

There are many predefined macros for XMPP specific XML namespaces defined
in [include/ns.hrl](include/ns.hrl) such as `?NS_CLIENT` or `?NS_ROSTER`.

> **WARNING**: you should **not** include `ns.hrl` in your erlang code.
> Include `xmpp.hrl` instead. Consult this file only to obtain a macro
> name for the required namespace.

There is also [get_ns/1](doc/API.md#get_ns1) function which can be used
to obtain a namespace of `xmpp_element()` or from `xmlel()` element.

## XMPP addresses

An XMPP address (aka Jabber ID or JID) can be represented using
two types:
- `jid()`: a JID is represented by a record `#jid{}`.
  This type is used to represent JIDs in XMPP elements.
- `ljid()`: a JID is represented by a tuple `{User, Server, Resource}`
  where `User`, `Server` and `Resource` are stringprepped version of
  a nodepart, namepart and resourcepart of a JID respectively.
  This representation is useful for JIDs comparison and when a JID
  should be used as a key (in a Mnesia database, ETS table, etc.)

Both types and the record are defined in [include/jid.hrl](include/jid.hrl).

> **WARNING**: you should **not** include `jid.hrl` in your erlang code.
> Include `xmpp.hrl` instead.

Functions for working with JIDs are provided by [jid](doc/API.md#jid) module.

## Language translation

The library uses a callback function in order to perform language
translation. The translation is applied when constructing
[text](#text-elements) or [error](#error-elements) elements.
To set the callback one can use [set_tr_callback/1](doc/API.md#set_tr_callback1)
function. By default, no translation is performed.

# Supported XMPP elements

XMPP elements from the following documents are supported.
For more details check the file [xmpp.doap](xmpp.doap)
and its nice display in [Erlang/Elixir XMPP at xmpp.org](https://xmpp.org/software/erlang-elixir-xmpp/).

- [RFC 6120](https://tools.ietf.org/html/rfc6120): XMPP Core
- [RFC 6121](https://tools.ietf.org/html/rfc6121): XMPP Instant Messaging and Presence
- [RFC 9266](https://tools.ietf.org/html/rfc9266): Channel Bindings for TLS 1.3
- [XEP-0004](https://xmpp.org/extensions/xep-0004.html):  Data Forms
- [XEP-0012](https://xmpp.org/extensions/xep-0012.html):  Last Activity
- [XEP-0013](https://xmpp.org/extensions/xep-0013.html):  Flexible Offline Message Retrieval
- [XEP-0016](https://xmpp.org/extensions/xep-0016.html):  Privacy Lists
- [XEP-0022](https://xmpp.org/extensions/xep-0022.html):  Message Events
- [XEP-0023](https://xmpp.org/extensions/xep-0023.html):  Message Expiration
- [XEP-0030](https://xmpp.org/extensions/xep-0030.html):  Service Discovery
- [XEP-0033](https://xmpp.org/extensions/xep-0033.html):  Extended Stanza Addressing
- [XEP-0039](https://xmpp.org/extensions/xep-0039.html):  Statistics Gathering
- [XEP-0045](https://xmpp.org/extensions/xep-0045.html):  Multi-User Chat
- [XEP-0047](https://xmpp.org/extensions/xep-0047.html):  In-Band Bytestreams
- [XEP-0048](https://xmpp.org/extensions/xep-0048.html):  Bookmarks
- [XEP-0049](https://xmpp.org/extensions/xep-0049.html):  Private XML Storage
- [XEP-0050](https://xmpp.org/extensions/xep-0050.html):  Ad-Hoc Commands
- [XEP-0054](https://xmpp.org/extensions/xep-0054.html):  vcard-temp
- [XEP-0055](https://xmpp.org/extensions/xep-0055.html):  Jabber Search
- [XEP-0059](https://xmpp.org/extensions/xep-0059.html):  Result Set Management
- [XEP-0060](https://xmpp.org/extensions/xep-0060.html):  Publish-Subscribe
- [XEP-0065](https://xmpp.org/extensions/xep-0065.html):  SOCKS5 Bytestreams
- [XEP-0066](https://xmpp.org/extensions/xep-0066.html):  Out of Band Data
- [XEP-0077](https://xmpp.org/extensions/xep-0077.html):  In-Band Registration
- [XEP-0078](https://xmpp.org/extensions/xep-0078.html):  Non-SASL Authentication
- [XEP-0084](https://xmpp.org/extensions/xep-0084.html):  User Avatar
- [XEP-0085](https://xmpp.org/extensions/xep-0085.html):  Chat State Notifications
- [XEP-0092](https://xmpp.org/extensions/xep-0092.html):  Software Version
- [XEP-0114](https://xmpp.org/extensions/xep-0114.html):  Jabber Component Protocol
- [XEP-0115](https://xmpp.org/extensions/xep-0115.html):  Entity Capabilities
- [XEP-0131](https://xmpp.org/extensions/xep-0131.html):  Stanza Headers and Internet Metadata
- [XEP-0138](https://xmpp.org/extensions/xep-0138.html):  Stream Compression
- [XEP-0153](https://xmpp.org/extensions/xep-0153.html):  vCard-Based Avatars
- [XEP-0158](https://xmpp.org/extensions/xep-0158.html):  CAPTCHA Forms
- [XEP-0166](https://xmpp.org/extensions/xep-0166.html):  Jingle
- [XEP-0172](https://xmpp.org/extensions/xep-0172.html):  User Nickname
- [XEP-0184](https://xmpp.org/extensions/xep-0184.html):  Message Delivery Receipts
- [XEP-0191](https://xmpp.org/extensions/xep-0191.html):  Blocking Command
- [XEP-0198](https://xmpp.org/extensions/xep-0198.html):  Stream Management
- [XEP-0199](https://xmpp.org/extensions/xep-0199.html):  XMPP Ping
- [XEP-0202](https://xmpp.org/extensions/xep-0202.html):  Entity Time
- [XEP-0203](https://xmpp.org/extensions/xep-0203.html):  Delayed Delivery
- [XEP-0215](https://xmpp.org/extensions/xep-0215.html):  External Service Discovery
- [XEP-0220](https://xmpp.org/extensions/xep-0220.html):  Server Dialback
- [XEP-0221](https://xmpp.org/extensions/xep-0221.html):  Data Forms Media Element
- [XEP-0231](https://xmpp.org/extensions/xep-0231.html):  Bits of Binary
- [XEP-0234](https://xmpp.org/extensions/xep-0234.html):  Jingle File Transfer
- [XEP-0249](https://xmpp.org/extensions/xep-0249.html):  Direct MUC Invitations
- [XEP-0260](https://xmpp.org/extensions/xep-0260.html):  Jingle SOCKS5 Bytestreams Transport Method
- [XEP-0261](https://xmpp.org/extensions/xep-0261.html):  Jingle In-Band Bytestreams Transport Method
- [XEP-0264](https://xmpp.org/extensions/xep-0264.html):  Jingle Content Thumbnails
- [XEP-0279](https://xmpp.org/extensions/xep-0279.html):  Server IP Check
- [XEP-0280](https://xmpp.org/extensions/xep-0280.html):  Message Carbons
- [XEP-0297](https://xmpp.org/extensions/xep-0297.html):  Stanza Forwarding
- [XEP-0300](https://xmpp.org/extensions/xep-0300.html):  Use of Cryptographic Hash Functions in XMPP
- [XEP-0313](https://xmpp.org/extensions/xep-0313.html):  Message Archive Management
- [XEP-0319](https://xmpp.org/extensions/xep-0319.html):  Last User Interaction in Presence
- [XEP-0328](https://xmpp.org/extensions/xep-0328.html):  JID Prep
- [XEP-0333](https://xmpp.org/extensions/xep-0333.html):  Chat Markers
- [XEP-0334](https://xmpp.org/extensions/xep-0334.html):  Message Processing Hints
- [XEP-0352](https://xmpp.org/extensions/xep-0352.html):  Client State Indication
- [XEP-0355](https://xmpp.org/extensions/xep-0355.html):  Namespace Delegation
- [XEP-0356](https://xmpp.org/extensions/xep-0356.html):  Privileged Entity
- [XEP-0357](https://xmpp.org/extensions/xep-0357.html):  Push Notifications
- [XEP-0359](https://xmpp.org/extensions/xep-0359.html):  Unique and Stable Stanza IDs
- [XEP-0363](https://xmpp.org/extensions/xep-0363.html):  HTTP File Upload
- [XEP-0369](https://xmpp.org/extensions/xep-0369.html):  Mediated Information eXchange (MIX)
- [XEP-0377](https://xmpp.org/extensions/xep-0377.html):  Spam Reporting
- [XEP-0386](https://xmpp.org/extensions/xep-0386.html):  Bind 2
- [XEP-0388](https://xmpp.org/extensions/xep-0388.html):  Extensible SASL Profile
- [XEP-0402](https://xmpp.org/extensions/xep-0402.html):  PEP Native Bookmarks
- [XEP-0403](https://xmpp.org/extensions/xep-0403.html):  MIX: Presence Support
- [XEP-0405](https://xmpp.org/extensions/xep-0405.html):  MIX: Participant Server Requirements
- [XEP-0417](https://xmpp.org/extensions/xep-0417.html):  E2E Authentication in XMPP: Certificate Issuance and Revocation
- [XEP-0421](https://xmpp.org/extensions/xep-0421.html):  Anonymous unique occupant identifiers for MUCs
- [XEP-0422](https://xmpp.org/extensions/xep-0422.html):  Message Fastening
- [XEP-0424](https://xmpp.org/extensions/xep-0424.html):  Message Retraction
- [XEP-0425](https://xmpp.org/extensions/xep-0425.html):  Message Moderation
- [XEP-0430](https://xmpp.org/extensions/xep-0430.html):  Inbox
- [XEP-0440](https://xmpp.org/extensions/xep-0440.html):  SASL Channel-Binding Type Capability
- [XEP-0474](https://xmpp.org/extensions/xep-0474.html):  SASL SCRAM Downgrade Protection
- [draft-cridland-xmpp-session-01](https://tools.ietf.org/html/draft-cridland-xmpp-session-01): XMPP Session Establishment

As well as some proprietary extensions from [ProcessOne](https://www.process-one.net)
