-- 1. پێناسەکردنا ڕەنگان
black = Color.new(15, 15, 15)
white = Color.new(255, 255, 255)
green = Color.new(0, 255, 0)
red = Color.new(255, 0, 0)
gray = Color.new(40, 40, 40)
yellow = Color.new(255, 255, 0)
lightGray = Color.new(200, 200, 200)

-- 2. لۆدکرنا دەنگان
bgMusic = Music.load("music.mp3")
caughtSound = Sound.load("caught.wav")
if bgMusic then Music.play(bgMusic, true) end

-- 3. جێگیرکرنا یاریزان و ڕوبۆتی
pX, pY = 320, 240
botX, botY = 100, 100
botDirX, botDirY = 2, 2
botSpeed, stamina = 1.5, 100
score, ticks, gameState = 0, 0, "play"
isHiding = false
playerColor = green

-- 4. لۆپێ سەرەکی
while true do
    pad = Controls.read()
    screen:clear(black)

    if gameState == "play" then
        -- لڤینا یاریزانی دگەل سنوردارکرنا کەناران
        if pad:up() then pY = pY - 3 end
        if pad:down() then pY = pY + 3 end
        if pad:left() then pX = pX - 3 end
        if pad:right() then pX = pX + 3 end
        
        if pX < 0 then pX = 0 end
        if pX > 620 then pX = 620 end
        if pY < 0 then pY = 0 end
        if pY > 460 then pY = 460 end

        -- گۆهرینا ڕەنگان
        if pad:triangle() then green = yellow end
        if pad:circle() then green = lightGray end

        -- میکانیزما وزێ و خۆڤەشارتنێ
        if pad:cross() and stamina > 0 then
            isHiding = true
            playerColor = gray
            stamina = math.max(0, stamina - 0.4)
        else
            isHiding = false
            playerColor = green
            stamina = math.min(100, stamina + 0.2)
        end

        -- AI یا ڕوبۆتی
        if not isHiding then
            if botX < pX then botX = botX + botSpeed end
            if botX > pX then botX = botX - botSpeed end
            if botY < pY then botY = botY + botSpeed end
            if botY > pY then botY = botY - botSpeed end
        else
            botX = botX + botDirX
            botY = botY + botDirY
            if botX < 10 or botX > 620 then botDirX = -botDirX end
            if botY < 10 or botY > 470 then botDirY = -botDirY end
        end

        -- پۆینت
        ticks = ticks + 1
        if ticks >= 60 then
            score = score + 1
            ticks = 0
            if score % 10 == 0 then botSpeed = botSpeed + 0.5 end
        end

        -- پشکنینا گرتنێ
        if math.sqrt((pX-botX)^2 + (pY-botY)^2) < 20 and not isHiding then
            gameState = "caught"
            if bgMusic then Music.stop() end
            if caughtSound then Sound.play(caughtSound) end
        end

        -- کێشانا توخمێن یاریێ
        screen:fillRect(pX, pY, 20, 20, playerColor)
        screen:fillRect(botX, botY, 20, 20, red)
        screen:print(10, 10, "SCORE: " .. score .. " | STAMINA: " .. math.floor(stamina), white)

    elseif gameState == "caught" then
        screen:print(200, 200, "THE ROBOT CAUGHT YOU!", red)

        if pad:start() then
            pX, pY = 320, 240
            botX, botY = 100, 100
            botSpeed = 1.5
            stamina = 100
            score = 0
            ticks = 0
            green = Color.new(0, 255, 0)
            playerColor = green
            gameState = "play"

            if bgMusic then
                Music.play(bgMusic, true)
            end
        end
    end

    screen.flip()
end
