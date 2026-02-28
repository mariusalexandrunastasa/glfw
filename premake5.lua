project "GLFW"
    kind "StaticLib"
    language "C"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("obj/" .. outputdir .. "/%{prj.name}")

    files
    {
        "include/GLFW/glfw3.h",
        "include/GLFW/glfw3native.h",
        "src/*.c"
    }

    filter "system:windows"
        systemversion "latest"
        staticruntime "On"

        files
        {
            "src/*.c",
        }

        defines
        {
            "_GLFW_WIN32",
            "_CRT_SECURE_NO_WARNINGS"
        }
    filter { "system:windows", "configurations:Release" }
        buildoptions "/MT"

    filter "system:linux"
        pic "On"
        defines { "_GLFW_X11" }    -- Enable X11 backend
        links { "X11", "pthread", "dl", "m", "GL" } -- required Linux libs
        buildoptions { "-fPIC" }

    filter "configurations:Debug"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        runtime "Release"
        optimize "speed"

    filter "configurations:Dist"
        runtime "Release"
        optimize "speed"
        symbols "off"
        filter "system:windows"

    filter { "configurations:Dist", "system:windows" }
        if _G.vsprops then
            vsprops { ["VcpkgConfiguration"] = "Release" }
        end
