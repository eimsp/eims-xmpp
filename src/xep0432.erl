%% Created automatically by XML generator (fxml_gen.erl)
%% Source: xmpp_codec.spec

-module(xep0432).

-compile(export_all).

do_decode(<<"payload">>, <<"urn:xmpp:json-msg:0">>, El,
          Opts) ->
    decode_message_payload(<<"urn:xmpp:json-msg:0">>,
                           Opts,
                           El);
do_decode(<<"json">>, <<"urn:xmpp:json:0">>, El,
          Opts) ->
    decode_payload_json(<<"urn:xmpp:json:0">>, Opts, El);
do_decode(Name, <<>>, _, _) ->
    erlang:error({xmpp_codec, {missing_tag_xmlns, Name}});
do_decode(Name, XMLNS, _, _) ->
    erlang:error({xmpp_codec, {unknown_tag, Name, XMLNS}}).

tags() ->
    [{<<"payload">>, <<"urn:xmpp:json-msg:0">>},
     {<<"json">>, <<"urn:xmpp:json:0">>}].

do_encode({payload_json, _} = Json, TopXMLNS) ->
    encode_payload_json(Json, TopXMLNS);
do_encode({message_payload, _, _} = Payload,
          TopXMLNS) ->
    encode_message_payload(Payload, TopXMLNS).

do_get_name({message_payload, _, _}) -> <<"payload">>;
do_get_name({payload_json, _}) -> <<"json">>.

do_get_ns({message_payload, _, _}) ->
    <<"urn:xmpp:json-msg:0">>;
do_get_ns({payload_json, _}) -> <<"urn:xmpp:json:0">>.

pp(payload_json, 1) -> [data];
pp(message_payload, 2) -> [datatype, json];
pp(_, _) -> no.

records() -> [{payload_json, 1}, {message_payload, 2}].

decode_message_payload(__TopXMLNS, __Opts,
                       {xmlel, <<"payload">>, _attrs, _els}) ->
    Json = decode_message_payload_els(__TopXMLNS,
                                      __Opts,
                                      _els,
                                      undefined),
    Datatype = decode_message_payload_attrs(__TopXMLNS,
                                            _attrs,
                                            undefined),
    {message_payload, Datatype, Json}.

decode_message_payload_els(__TopXMLNS, __Opts, [],
                           Json) ->
    Json;
decode_message_payload_els(__TopXMLNS, __Opts,
                           [{xmlel, <<"json">>, _attrs, _} = _el | _els],
                           Json) ->
    case xmpp_codec:get_attr(<<"xmlns">>,
                             _attrs,
                             __TopXMLNS)
        of
        <<"urn:xmpp:json:0">> ->
            decode_message_payload_els(__TopXMLNS,
                                       __Opts,
                                       _els,
                                       decode_payload_json(<<"urn:xmpp:json:0">>,
                                                           __Opts,
                                                           _el));
        _ ->
            decode_message_payload_els(__TopXMLNS,
                                       __Opts,
                                       _els,
                                       Json)
    end;
decode_message_payload_els(__TopXMLNS, __Opts,
                           [_ | _els], Json) ->
    decode_message_payload_els(__TopXMLNS,
                               __Opts,
                               _els,
                               Json).

decode_message_payload_attrs(__TopXMLNS,
                             [{<<"datatype">>, _val} | _attrs], _Datatype) ->
    decode_message_payload_attrs(__TopXMLNS, _attrs, _val);
decode_message_payload_attrs(__TopXMLNS, [_ | _attrs],
                             Datatype) ->
    decode_message_payload_attrs(__TopXMLNS,
                                 _attrs,
                                 Datatype);
decode_message_payload_attrs(__TopXMLNS, [],
                             Datatype) ->
    decode_message_payload_attr_datatype(__TopXMLNS,
                                         Datatype).

encode_message_payload({message_payload,
                        Datatype,
                        Json},
                       __TopXMLNS) ->
    __NewTopXMLNS =
        xmpp_codec:choose_top_xmlns(<<"urn:xmpp:json-msg:0">>,
                                    [],
                                    __TopXMLNS),
    _els =
        lists:reverse('encode_message_payload_$json'(Json,
                                                     __NewTopXMLNS,
                                                     [])),
    _attrs = encode_message_payload_attr_datatype(Datatype,
                                                  xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
                                                                             __TopXMLNS)),
    {xmlel, <<"payload">>, _attrs, _els}.

'encode_message_payload_$json'(undefined, __TopXMLNS,
                               _acc) ->
    _acc;
'encode_message_payload_$json'(Json, __TopXMLNS,
                               _acc) ->
    [encode_payload_json(Json, __TopXMLNS) | _acc].

decode_message_payload_attr_datatype(__TopXMLNS,
                                     undefined) ->
    <<>>;
decode_message_payload_attr_datatype(__TopXMLNS,
                                     _val) ->
    _val.

encode_message_payload_attr_datatype(<<>>, _acc) ->
    _acc;
encode_message_payload_attr_datatype(_val, _acc) ->
    [{<<"datatype">>, _val} | _acc].

decode_payload_json(__TopXMLNS, __Opts,
                    {xmlel, <<"json">>, _attrs, _els}) ->
    Data = decode_payload_json_els(__TopXMLNS,
                                   __Opts,
                                   _els,
                                   <<>>),
    {payload_json, Data}.

decode_payload_json_els(__TopXMLNS, __Opts, [], Data) ->
    decode_payload_json_cdata(__TopXMLNS, Data);
decode_payload_json_els(__TopXMLNS, __Opts,
                        [{xmlcdata, _data} | _els], Data) ->
    decode_payload_json_els(__TopXMLNS,
                            __Opts,
                            _els,
                            <<Data/binary, _data/binary>>);
decode_payload_json_els(__TopXMLNS, __Opts, [_ | _els],
                        Data) ->
    decode_payload_json_els(__TopXMLNS, __Opts, _els, Data).

encode_payload_json({payload_json, Data}, __TopXMLNS) ->
    __NewTopXMLNS =
        xmpp_codec:choose_top_xmlns(<<"urn:xmpp:json:0">>,
                                    [],
                                    __TopXMLNS),
    _els = encode_payload_json_cdata(Data, []),
    _attrs = xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
                                        __TopXMLNS),
    {xmlel, <<"json">>, _attrs, _els}.

decode_payload_json_cdata(__TopXMLNS, <<>>) -> <<>>;
decode_payload_json_cdata(__TopXMLNS, _val) -> _val.

encode_payload_json_cdata(<<>>, _acc) -> _acc;
encode_payload_json_cdata(_val, _acc) ->
    [{xmlcdata, _val} | _acc].
