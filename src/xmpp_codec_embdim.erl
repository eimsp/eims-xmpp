%% Created automatically by XML generator (fxml_gen.erl)
%% Source: xmpp_codec_embdim.spec

-module(xmpp_codec_embdim).

-compile(export_all).

do_decode(<<"entities">>, <<"urn:xmpp:message-entity">>,
          El, Opts) ->
    decode_message_entities(<<"urn:xmpp:message-entity">>,
                            Opts,
                            El);
do_decode(<<"entity">>, <<"urn:xmpp:message-entity">>,
          El, Opts) ->
    decode_message_entity(<<"urn:xmpp:message-entity">>,
                          Opts,
                          El);
do_decode(<<"bot">>, <<"urn:eims:system">>, El,
          Opts) ->
    decode_bot(<<"urn:eims:system">>, Opts, El);
do_decode(<<"body">>, <<"urn:xmpp:upload:0">>, El,
          Opts) ->
    decode_message_upload_body(<<"urn:xmpp:upload:0">>,
                               Opts,
                               El);
do_decode(<<"upload">>, <<"urn:xmpp:upload:0">>, El,
          Opts) ->
    decode_message_upload(<<"urn:xmpp:upload:0">>,
                          Opts,
                          El);
do_decode(Name, <<>>, _, _) ->
    erlang:error({xmpp_codec, {missing_tag_xmlns, Name}});
do_decode(Name, XMLNS, _, _) ->
    erlang:error({xmpp_codec, {unknown_tag, Name, XMLNS}}).

tags() ->
    [{<<"entities">>, <<"urn:xmpp:message-entity">>},
     {<<"entity">>, <<"urn:xmpp:message-entity">>},
     {<<"bot">>, <<"urn:eims:system">>},
     {<<"body">>, <<"urn:xmpp:upload:0">>},
     {<<"upload">>, <<"urn:xmpp:upload:0">>}].

do_encode({message_upload, _} = Upload, TopXMLNS) ->
    encode_message_upload(Upload, TopXMLNS);
do_encode({message_upload_body, _, _} = Body,
          TopXMLNS) ->
    encode_message_upload_body(Body, TopXMLNS);
do_encode({bot, _, _, _, _} = Bot, TopXMLNS) ->
    encode_bot(Bot, TopXMLNS);
do_encode({message_entity, _, _, _} = Entity,
          TopXMLNS) ->
    encode_message_entity(Entity, TopXMLNS);
do_encode({message_entities, _} = Entities, TopXMLNS) ->
    encode_message_entities(Entities, TopXMLNS).

do_get_name({bot, _, _, _, _}) -> <<"bot">>;
do_get_name({message_entities, _}) -> <<"entities">>;
do_get_name({message_entity, _, _, _}) -> <<"entity">>;
do_get_name({message_upload, _}) -> <<"upload">>;
do_get_name({message_upload_body, _, _}) -> <<"body">>.

do_get_ns({bot, _, _, _, _}) ->
    <<"urn:eims:system">>;
do_get_ns({message_entities, _}) ->
    <<"urn:xmpp:message-entity">>;
do_get_ns({message_entity, _, _, _}) ->
    <<"urn:xmpp:message-entity">>;
do_get_ns({message_upload, _}) ->
    <<"urn:xmpp:upload:0">>;
do_get_ns({message_upload_body, _, _}) ->
    <<"urn:xmpp:upload:0">>.

pp(message_upload, 1) -> [body];
pp(message_upload_body, 2) -> [url, title];
pp(bot, 4) -> [nick, type, hash, parse_mode];
pp(message_entity, 3) -> [type, offset, length];
pp(message_entities, 1) -> [items];
pp(_, _) -> no.

records() ->
    [{message_upload, 1},
     {message_upload_body, 2},
     {bot, 4},
     {message_entity, 3},
     {message_entities, 1}].

dec_enum(Val, Enums) ->
    AtomVal = erlang:binary_to_existing_atom(Val, utf8),
    case lists:member(AtomVal, Enums) of
        true -> AtomVal
    end.

dec_int(Val, Min, Max) ->
    case erlang:binary_to_integer(Val) of
        Int when Int =< Max, Min == infinity -> Int;
        Int when Int =< Max, Int >= Min -> Int
    end.

enc_enum(Atom) -> erlang:atom_to_binary(Atom, utf8).

enc_int(Int) -> erlang:integer_to_binary(Int).

decode_message_entities(__TopXMLNS, __Opts,
                        {xmlel, <<"entities">>, _attrs, _els}) ->
    Items = decode_message_entities_els(__TopXMLNS,
                                        __Opts,
                                        _els,
                                        []),
    {message_entities, Items}.

decode_message_entities_els(__TopXMLNS, __Opts, [],
                            Items) ->
    lists:reverse(Items);
decode_message_entities_els(__TopXMLNS, __Opts,
                            [{xmlel, <<"entity">>, _attrs, _} = _el | _els],
                            Items) ->
    case xmpp_codec:get_attr(<<"xmlns">>,
                             _attrs,
                             __TopXMLNS)
        of
        <<"urn:xmpp:message-entity">> ->
            decode_message_entities_els(__TopXMLNS,
                                        __Opts,
                                        _els,
                                        [decode_message_entity(<<"urn:xmpp:message-entity">>,
                                                               __Opts,
                                                               _el)
                                         | Items]);
        _ ->
            decode_message_entities_els(__TopXMLNS,
                                        __Opts,
                                        _els,
                                        Items)
    end;
decode_message_entities_els(__TopXMLNS, __Opts,
                            [_ | _els], Items) ->
    decode_message_entities_els(__TopXMLNS,
                                __Opts,
                                _els,
                                Items).

encode_message_entities({message_entities, Items},
                        __TopXMLNS) ->
    __NewTopXMLNS =
        xmpp_codec:choose_top_xmlns(<<"urn:xmpp:message-entity">>,
                                    [],
                                    __TopXMLNS),
    _els =
        lists:reverse('encode_message_entities_$items'(Items,
                                                       __NewTopXMLNS,
                                                       [])),
    _attrs = xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
                                        __TopXMLNS),
    {xmlel, <<"entities">>, _attrs, _els}.

'encode_message_entities_$items'([], __TopXMLNS,
                                 _acc) ->
    _acc;
'encode_message_entities_$items'([Items | _els],
                                 __TopXMLNS, _acc) ->
    'encode_message_entities_$items'(_els,
                                     __TopXMLNS,
                                     [encode_message_entity(Items, __TopXMLNS)
                                      | _acc]).

decode_message_entity(__TopXMLNS, __Opts,
                      {xmlel, <<"entity">>, _attrs, _els}) ->
    {Type, Offset, Length} =
        decode_message_entity_attrs(__TopXMLNS,
                                    _attrs,
                                    undefined,
                                    undefined,
                                    undefined),
    {message_entity, Type, Offset, Length}.

decode_message_entity_attrs(__TopXMLNS,
                            [{<<"type">>, _val} | _attrs], _Type, Offset,
                            Length) ->
    decode_message_entity_attrs(__TopXMLNS,
                                _attrs,
                                _val,
                                Offset,
                                Length);
decode_message_entity_attrs(__TopXMLNS,
                            [{<<"offset">>, _val} | _attrs], Type, _Offset,
                            Length) ->
    decode_message_entity_attrs(__TopXMLNS,
                                _attrs,
                                Type,
                                _val,
                                Length);
decode_message_entity_attrs(__TopXMLNS,
                            [{<<"length">>, _val} | _attrs], Type, Offset,
                            _Length) ->
    decode_message_entity_attrs(__TopXMLNS,
                                _attrs,
                                Type,
                                Offset,
                                _val);
decode_message_entity_attrs(__TopXMLNS, [_ | _attrs],
                            Type, Offset, Length) ->
    decode_message_entity_attrs(__TopXMLNS,
                                _attrs,
                                Type,
                                Offset,
                                Length);
decode_message_entity_attrs(__TopXMLNS, [], Type,
                            Offset, Length) ->
    {decode_message_entity_attr_type(__TopXMLNS, Type),
     decode_message_entity_attr_offset(__TopXMLNS, Offset),
     decode_message_entity_attr_length(__TopXMLNS, Length)}.

encode_message_entity({message_entity,
                       Type,
                       Offset,
                       Length},
                      __TopXMLNS) ->
    __NewTopXMLNS =
        xmpp_codec:choose_top_xmlns(<<"urn:xmpp:message-entity">>,
                                    [],
                                    __TopXMLNS),
    _els = [],
    _attrs = encode_message_entity_attr_length(Length,
                                               encode_message_entity_attr_offset(Offset,
                                                                                 encode_message_entity_attr_type(Type,
                                                                                                                 xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
                                                                                                                                            __TopXMLNS)))),
    {xmlel, <<"entity">>, _attrs, _els}.

decode_message_entity_attr_type(__TopXMLNS,
                                undefined) ->
    undefined;
decode_message_entity_attr_type(__TopXMLNS, _val) ->
    case catch dec_enum(_val,
                        [bold,
                         italic,
                         underline,
                         strikethrough,
                         code,
                         pre,
                         text_link,
                         mention,
                         hashtag,
                         monospace,
                         spoiler,
                         bot_command,
                         json])
        of
        {'EXIT', _} ->
            erlang:error({xmpp_codec,
                          {bad_attr_value,
                           <<"type">>,
                           <<"entity">>,
                           __TopXMLNS}});
        _res -> _res
    end.

encode_message_entity_attr_type(_val, _acc) ->
    [{<<"type">>, enc_enum(_val)} | _acc].

decode_message_entity_attr_offset(__TopXMLNS,
                                  undefined) ->
    0;
decode_message_entity_attr_offset(__TopXMLNS, _val) ->
    case catch dec_int(_val, 0, infinity) of
        {'EXIT', _} ->
            erlang:error({xmpp_codec,
                          {bad_attr_value,
                           <<"offset">>,
                           <<"entity">>,
                           __TopXMLNS}});
        _res -> _res
    end.

encode_message_entity_attr_offset(0, _acc) -> _acc;
encode_message_entity_attr_offset(_val, _acc) ->
    [{<<"offset">>, enc_int(_val)} | _acc].

decode_message_entity_attr_length(__TopXMLNS,
                                  undefined) ->
    0;
decode_message_entity_attr_length(__TopXMLNS, _val) ->
    case catch dec_int(_val, 0, infinity) of
        {'EXIT', _} ->
            erlang:error({xmpp_codec,
                          {bad_attr_value,
                           <<"length">>,
                           <<"entity">>,
                           __TopXMLNS}});
        _res -> _res
    end.

encode_message_entity_attr_length(0, _acc) -> _acc;
encode_message_entity_attr_length(_val, _acc) ->
    [{<<"length">>, enc_int(_val)} | _acc].

decode_bot(__TopXMLNS, __Opts,
           {xmlel, <<"bot">>, _attrs, _els}) ->
    {Nick, Type, Hash, Parse_mode} =
        decode_bot_attrs(__TopXMLNS,
                         _attrs,
                         undefined,
                         undefined,
                         undefined,
                         undefined),
    {bot, Nick, Type, Hash, Parse_mode}.

decode_bot_attrs(__TopXMLNS,
                 [{<<"nick">>, _val} | _attrs], _Nick, Type, Hash,
                 Parse_mode) ->
    decode_bot_attrs(__TopXMLNS,
                     _attrs,
                     _val,
                     Type,
                     Hash,
                     Parse_mode);
decode_bot_attrs(__TopXMLNS,
                 [{<<"type">>, _val} | _attrs], Nick, _Type, Hash,
                 Parse_mode) ->
    decode_bot_attrs(__TopXMLNS,
                     _attrs,
                     Nick,
                     _val,
                     Hash,
                     Parse_mode);
decode_bot_attrs(__TopXMLNS,
                 [{<<"hash">>, _val} | _attrs], Nick, Type, _Hash,
                 Parse_mode) ->
    decode_bot_attrs(__TopXMLNS,
                     _attrs,
                     Nick,
                     Type,
                     _val,
                     Parse_mode);
decode_bot_attrs(__TopXMLNS,
                 [{<<"parse_mode">>, _val} | _attrs], Nick, Type, Hash,
                 _Parse_mode) ->
    decode_bot_attrs(__TopXMLNS,
                     _attrs,
                     Nick,
                     Type,
                     Hash,
                     _val);
decode_bot_attrs(__TopXMLNS, [_ | _attrs], Nick, Type,
                 Hash, Parse_mode) ->
    decode_bot_attrs(__TopXMLNS,
                     _attrs,
                     Nick,
                     Type,
                     Hash,
                     Parse_mode);
decode_bot_attrs(__TopXMLNS, [], Nick, Type, Hash,
                 Parse_mode) ->
    {decode_bot_attr_nick(__TopXMLNS, Nick),
     decode_bot_attr_type(__TopXMLNS, Type),
     decode_bot_attr_hash(__TopXMLNS, Hash),
     decode_bot_attr_parse_mode(__TopXMLNS, Parse_mode)}.

encode_bot({bot, Nick, Type, Hash, Parse_mode},
           __TopXMLNS) ->
    __NewTopXMLNS =
        xmpp_codec:choose_top_xmlns(<<"urn:eims:system">>,
                                    [],
                                    __TopXMLNS),
    _els = [],
    _attrs = encode_bot_attr_parse_mode(Parse_mode,
                                        encode_bot_attr_hash(Hash,
                                                             encode_bot_attr_type(Type,
                                                                                  encode_bot_attr_nick(Nick,
                                                                                                       xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
                                                                                                                                  __TopXMLNS))))),
    {xmlel, <<"bot">>, _attrs, _els}.

decode_bot_attr_nick(__TopXMLNS, undefined) -> <<>>;
decode_bot_attr_nick(__TopXMLNS, _val) -> _val.

encode_bot_attr_nick(<<>>, _acc) -> _acc;
encode_bot_attr_nick(_val, _acc) ->
    [{<<"nick">>, _val} | _acc].

decode_bot_attr_type(__TopXMLNS, undefined) -> system;
decode_bot_attr_type(__TopXMLNS, _val) -> _val.

encode_bot_attr_type(system, _acc) -> _acc;
encode_bot_attr_type(_val, _acc) ->
    [{<<"type">>, _val} | _acc].

decode_bot_attr_hash(__TopXMLNS, undefined) -> <<>>;
decode_bot_attr_hash(__TopXMLNS, _val) -> _val.

encode_bot_attr_hash(<<>>, _acc) -> _acc;
encode_bot_attr_hash(_val, _acc) ->
    [{<<"hash">>, _val} | _acc].

decode_bot_attr_parse_mode(__TopXMLNS, undefined) ->
    none;
decode_bot_attr_parse_mode(__TopXMLNS, _val) ->
    case catch dec_enum(_val, [none, markdown, html]) of
        {'EXIT', _} ->
            erlang:error({xmpp_codec,
                          {bad_attr_value,
                           <<"parse_mode">>,
                           <<"bot">>,
                           __TopXMLNS}});
        _res -> _res
    end.

encode_bot_attr_parse_mode(_val, _acc) ->
    [{<<"parse_mode">>, enc_enum(_val)} | _acc].

decode_message_upload_body(__TopXMLNS, __Opts,
                           {xmlel, <<"body">>, _attrs, _els}) ->
    {Url, Title} =
        decode_message_upload_body_attrs(__TopXMLNS,
                                         _attrs,
                                         undefined,
                                         undefined),
    {message_upload_body, Url, Title}.

decode_message_upload_body_attrs(__TopXMLNS,
                                 [{<<"url">>, _val} | _attrs], _Url, Title) ->
    decode_message_upload_body_attrs(__TopXMLNS,
                                     _attrs,
                                     _val,
                                     Title);
decode_message_upload_body_attrs(__TopXMLNS,
                                 [{<<"title">>, _val} | _attrs], Url, _Title) ->
    decode_message_upload_body_attrs(__TopXMLNS,
                                     _attrs,
                                     Url,
                                     _val);
decode_message_upload_body_attrs(__TopXMLNS,
                                 [_ | _attrs], Url, Title) ->
    decode_message_upload_body_attrs(__TopXMLNS,
                                     _attrs,
                                     Url,
                                     Title);
decode_message_upload_body_attrs(__TopXMLNS, [], Url,
                                 Title) ->
    {decode_message_upload_body_attr_url(__TopXMLNS, Url),
     decode_message_upload_body_attr_title(__TopXMLNS,
                                           Title)}.

encode_message_upload_body({message_upload_body,
                            Url,
                            Title},
                           __TopXMLNS) ->
    __NewTopXMLNS =
        xmpp_codec:choose_top_xmlns(<<"urn:xmpp:upload:0">>,
                                    [],
                                    __TopXMLNS),
    _els = [],
    _attrs = encode_message_upload_body_attr_title(Title,
                                                   encode_message_upload_body_attr_url(Url,
                                                                                       xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
                                                                                                                  __TopXMLNS))),
    {xmlel, <<"body">>, _attrs, _els}.

decode_message_upload_body_attr_url(__TopXMLNS,
                                    undefined) ->
    erlang:error({xmpp_codec,
                  {missing_attr, <<"url">>, <<"body">>, __TopXMLNS}});
decode_message_upload_body_attr_url(__TopXMLNS, _val) ->
    _val.

encode_message_upload_body_attr_url(_val, _acc) ->
    [{<<"url">>, _val} | _acc].

decode_message_upload_body_attr_title(__TopXMLNS,
                                      undefined) ->
    <<>>;
decode_message_upload_body_attr_title(__TopXMLNS,
                                      _val) ->
    _val.

encode_message_upload_body_attr_title(<<>>, _acc) ->
    _acc;
encode_message_upload_body_attr_title(_val, _acc) ->
    [{<<"title">>, _val} | _acc].

decode_message_upload(__TopXMLNS, __Opts,
                      {xmlel, <<"upload">>, _attrs, _els}) ->
    Body = decode_message_upload_els(__TopXMLNS,
                                     __Opts,
                                     _els,
                                     []),
    {message_upload, Body}.

decode_message_upload_els(__TopXMLNS, __Opts, [],
                          Body) ->
    lists:reverse(Body);
decode_message_upload_els(__TopXMLNS, __Opts,
                          [{xmlel, <<"body">>, _attrs, _} = _el | _els],
                          Body) ->
    case xmpp_codec:get_attr(<<"xmlns">>,
                             _attrs,
                             __TopXMLNS)
        of
        <<"urn:xmpp:upload:0">> ->
            decode_message_upload_els(__TopXMLNS,
                                      __Opts,
                                      _els,
                                      [decode_message_upload_body(<<"urn:xmpp:upload:0">>,
                                                                  __Opts,
                                                                  _el)
                                       | Body]);
        _ ->
            decode_message_upload_els(__TopXMLNS,
                                      __Opts,
                                      _els,
                                      Body)
    end;
decode_message_upload_els(__TopXMLNS, __Opts,
                          [_ | _els], Body) ->
    decode_message_upload_els(__TopXMLNS,
                              __Opts,
                              _els,
                              Body).

encode_message_upload({message_upload, Body},
                      __TopXMLNS) ->
    __NewTopXMLNS =
        xmpp_codec:choose_top_xmlns(<<"urn:xmpp:upload:0">>,
                                    [],
                                    __TopXMLNS),
    _els = lists:reverse('encode_message_upload_$body'(Body,
                                                       __NewTopXMLNS,
                                                       [])),
    _attrs = xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
                                        __TopXMLNS),
    {xmlel, <<"upload">>, _attrs, _els}.

'encode_message_upload_$body'([], __TopXMLNS, _acc) ->
    _acc;
'encode_message_upload_$body'([Body | _els], __TopXMLNS,
                              _acc) ->
    'encode_message_upload_$body'(_els,
                                  __TopXMLNS,
                                  [encode_message_upload_body(Body, __TopXMLNS)
                                   | _acc]).
