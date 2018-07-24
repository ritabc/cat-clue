class Player < ActiveRecord::Base

  def end_turn
    players = Player.all
    last_player = players.last
    if self == last_player
      next_player = players.first
    else
      next_player = players.find(self.id + 1)
    end
    self.update(turn: 'f')
    next_player.update(turn: 't')
  end

  def roll_dice
    roll = rand(6) + 1
    self.update({:dice_roll => roll})
    roll
  end

<<<<<<< HEAD
  def move
    all_spaces = Space.all
    # if moves_left < dice_roll
      # allow player to click one away (no diagonally)
      # if they move
        # increase moves_left
      # end
      # if they move onto a door space, they have the option to click on the room to enter it.
        # then they can guess (change view to guess form)
    #
=======
  def save_guess(cat, weapon, room)
    cat_id = cat.id
    weapon_id = weapon.id
    room_id = room.id
    Player.where(id: self.id).update({:guess => [cat_id, weapon_id, room_id] })
  end

  def player_guess_match(cat, weapon, room)
    player_guess = [cat, weapon, room]
    cards_to_pick_from = Card.where(answer: 'f').where.not(player_id: self.id)
    returned_card = nil
    player_guess.shuffle.each do |guess|
      if cards_to_pick_from.include?(guess)
        returned_card = guess
        break
      else
        returned_card = false
      end
    end
    returned_card
>>>>>>> d76f1e6e8079d40b87f4e0475af79f3a2c66a66b
  end

end
