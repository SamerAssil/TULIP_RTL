unit TulipRTL;

interface

uses

{$IF CompilerVersion <= 23.0}
  Windows, SysUtils, Classes, Controls;
{$ELSE}
  Winapi.Windows, System.Classes, System.SysUtils, vcl.Controls;
{$ENDIF}


type
  TTulipRTL = class(TComponent)
  private
    FTarget: TWinControl;
    FActive: Boolean;
    procedure SetActive(const Value: Boolean);
    procedure SetTarget(const Value: TWinControl);
    { Private declarations }
  protected
    procedure DoRTL;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
  published
    property Active: Boolean read FActive write SetActive default false;
    property Target: TWinControl read FTarget write SetTarget;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TULIPsoft', [TTulipRTL]);
end;

{ TTulipRTL }

procedure TTulipRTL.DoRTL;
begin
  if (csDesigning in ComponentState) then
    exit;

  if not assigned(FTarget) then
    exit;

  if FActive then
  begin
    try
      SetWindowLong(FTarget.Handle, GWL_EXSTYLE,
        GetWindowLong(FTarget.Handle, GWL_EXSTYLE)
        or
        WS_EX_LAYOUTRTL
        or
        WS_EX_RIGHT
        );
    finally
    end;
  end
  else
  begin
    try
      SetWindowLong(FTarget.Handle, GWL_EXSTYLE,
        GetWindowLong(FTarget.Handle, GWL_EXSTYLE)
        and
        WS_EX_LAYOUTRTL
        and
        WS_EX_RIGHT
        )
    finally
    end;
  end;
end;

procedure TTulipRTL.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = TOperation.opRemove)
    and (csDesigning in ComponentState)
    and (AComponent = Target) then
  begin
    Target := nil;
    Active := false;
  end;
end;

procedure TTulipRTL.SetActive(const Value: Boolean);
begin
  FActive := Value;
  if assigned(FTarget) then
    DoRTL;
end;

procedure TTulipRTL.SetTarget(const Value: TWinControl);
begin
  FTarget := Value;
  if FActive then
    DoRTL
end;

end.
