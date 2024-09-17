open Helix

module Style = struct
  let button =
    Html.class_list
      [
        "bg-transparent";
        "hover:bg-blue-500";
        "text-blue-700";
        "font-semibold";
        "hover:text-white";
        "py-2";
        "px-4";
        "border";
        "border-blue-500";
        "hover:border-transparent";
        "rounded";
      ]
end

let counter () =
  let count = Signal.make 0 in
  let open Html in
  div
    [ class_list [ "max-w-80"; "mx-auto"; "p-8"; "m-4"; "text-xl" ] ]
    [
      div
        [ class_list [ "flex"; "flex-col"; "gap-y-2" ] ]
        [
          div
            [
              class_list [ "py-10"; "rounded"; "text-center"; "text-7xl" ];
              bind
                (fun n ->
                  if n < 0 then class_list [ "bg-red-100" ]
                  else if n > 0 then class_list [ "bg-blue-100" ]
                  else class_list [ "bg-gray-100" ])
                count;
            ]
            [ show (fun n -> span [] [ text (string_of_int n) ]) count ];
          button
            [ Style.button; on_click (fun () -> Signal.update (fun n -> n + 1) count) ]
            [ text "+" ];
          button
            [ Style.button; on_click (fun () -> Signal.update (fun n -> n - 1) count) ]
            [ text "-" ];
          button [ Style.button; on_click (fun () -> Signal.emit 0 count) ] [ text "Reset" ];
        ];
    ]

let () =
  match Stdweb.Dom.Document.get_element_by_id "root" with
  | Some root -> Html.mount root (counter ())
  | None -> failwith "No #root element found"
