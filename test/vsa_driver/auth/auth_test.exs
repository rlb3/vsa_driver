defmodule VsaDriver.AuthTest do
  use VsaDriver.DataCase

  alias VsaDriver.Auth

  describe "sessions" do
    alias VsaDriver.Auth.Session

    @valid_attrs %{email: "some email", password: "some password"}
    @update_attrs %{email: "some updated email", password: "some updated password"}
    @invalid_attrs %{email: nil, password: nil}

    def session_fixture(attrs \\ %{}) do
      {:ok, session} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_session()

      session
    end

    test "list_sessions/0 returns all sessions" do
      session = session_fixture()
      assert Auth.list_sessions() == [session]
    end

    test "get_session!/1 returns the session with given id" do
      session = session_fixture()
      assert Auth.get_session!(session.id) == session
    end

    test "create_session/1 with valid data creates a session" do
      assert {:ok, %Session{} = session} = Auth.create_session(@valid_attrs)
      assert session.email == "some email"
      assert session.password == "some password"
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_session(@invalid_attrs)
    end

    test "update_session/2 with valid data updates the session" do
      session = session_fixture()
      assert {:ok, session} = Auth.update_session(session, @update_attrs)
      assert %Session{} = session
      assert session.email == "some updated email"
      assert session.password == "some updated password"
    end

    test "update_session/2 with invalid data returns error changeset" do
      session = session_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_session(session, @invalid_attrs)
      assert session == Auth.get_session!(session.id)
    end

    test "delete_session/1 deletes the session" do
      session = session_fixture()
      assert {:ok, %Session{}} = Auth.delete_session(session)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_session!(session.id) end
    end

    test "change_session/1 returns a session changeset" do
      session = session_fixture()
      assert %Ecto.Changeset{} = Auth.change_session(session)
    end
  end
end
